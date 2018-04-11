#!/usr/bin/env sysbench
-- Copyright (C) 2006-2017 Alexey Kopytov <akopytov@gmail.com>

-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

-- ----------------------------------------------------------------------
-- Insert-Only OLTP benchmark
-- ----------------------------------------------------------------------

require("oltp_common")

sysbench.cmdline.options.start_id = {"Start id of primary key", 0}

sysbench.cmdline.commands.prepare = {
   function ()
      assert(sysbench.opt.tables <= sysbench.opt.threads, "this benchmark does not support " ..
                "--tables > --threads")

      if not sysbench.opt.auto_inc then
         assert(sysbench.opt.threads % sysbench.opt.tables == 0, "threads size should be times of tables" )
         local concurrency = (sysbench.opt.threads / sysbench.opt.tables)
         assert(sysbench.opt.table_size % concurrency == 0, "table size should be times of 'sysbench.opt.threads/sysbench.opt.tables'")
         local table_size = sysbench.opt.table_size
         local batch_size = (table_size / concurrency)
      end

      -- use snapshot not serializable
      if drv:name() == 'pgsql' then
         con:prepare("SET DEFAULT_TRANSACTION_ISOLATION TO SNAPSHOT").execute()
      end


      cmd_prepare()
   end,
   sysbench.cmdline.PARALLEL_COMMAND
}

thread_states = {
}

function prepare_statements()
   local table_name
   if not sysbench.opt.auto_inc then
      local concurrency = (sysbench.opt.threads / sysbench.opt.tables)
      local table_size = sysbench.opt.table_size
      local batch_size = (table_size / concurrency)
      -- rewrite the events to ours
      sysbench.opt.events = batch_size

      -- assert(sysbench.opt.events == batch_size, "[BUG] sysbench.opt.events: " .. sysbench.opt.events .. "should be rewrite to batch_size: " .. batch_size)

      -- init cur_id to batch start
      local cur_id = thread_id / sysbench.opt.tables * batch_size + sysbench.opt.start_id
      -- cut_ids[thread_id] = cur_id
      -- stop_ids[thread_id] = cur_id + batch_size
      thread_states[thread_id] = { cur_id = cur_id, stop_id = cur_id + batch_size }

      local table_id = thread_id % sysbench.opt.tables + 1
      table_name = "sbtest" .. table_id
   else
      local table_id = thread_id % sysbench.opt.tables + 1
      table_name = "sbtest" .. table_id
      insert_init = string.format("INSERT INTO %s (k, c, pad) VALUES", table_name)
      con:bulk_insert_init(insert_init)
   end


   local idx_cols = {}
   if sysbench.opt.secondary_num <= 1 then
      table.insert(idx_cols, "k")
   else
      for i = 1, sysbench.opt.secondary_num do
         table.insert(idx_cols, 'k' .. i)
      end
   end

   local insert_init = ''
   if not sysbench.opt.auto_inc then
      insert_init = string.format(
         "INSERT INTO %s (id, %s, c, pad) VALUES",
         table_name,
         table.concat(idx_cols, ",")
      )
   else
      insert_init = string.format(
         "INSERT INTO %s (%s, c, pad) VALUES",
         table_name,
         table.concat(idx_cols, ",")
      )
   end

   con:bulk_insert_init(insert_init)

end

function event()
   local ks_val = {}
   if sysbench.opt.secondary_num <= 1 then
      table.insert(ks_val, sysbench.rand.default(1, sysbench.opt.table_size))
   else
      for i = 1, sysbench.opt.secondary_num do
         table.insert(ks_val, sysbench.rand.default(1, sysbench.opt.table_size))
      end
   end
   sysbench.rand.default(1, sysbench.opt.table_size)
   local c_val = get_c_value()
   local pad_val = get_pad_value()
   if sysbench.opt.auto_inc then
      con:bulk_insert_next(
         string.format("(%s, '%s', '%s')", table.concat(ks_val, ','), c_val, pad_val)
      )
   else
      local cur_id = thread_states[thread_id].cur_id
      con:bulk_insert_next(
         string.format("(%d, %s, '%s', '%s')", cur_id,
                       table.concat(ks_val, ','),
                       c_val, pad_val)
      )
      -- cur_ids[thread_id] = cur_id + 1
      thread_states[thread_id].cur_id = cur_id + 1
      -- need to stop, if id is exceed the stop id
      if thread_states[thread_id].cur_id >= thread_states[thread_id].stop_id then
         return 0
      end
   end
end

function thread_done(thread_id)
   con:bulk_insert_done()
   con:disconnect()
end
