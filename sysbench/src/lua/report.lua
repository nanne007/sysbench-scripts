function report_cumulative_csv(stat)
   print("time_total(s), events, reads, writes, other, total, " ..
            "trans, queries, errors, trans/time_total(per sec), queries/time_total(per sec), errors/time_total(per sec), " ..
            "reconnects, reconnects/time_total(per sec), " ..
            "latency_min(ms), latency_avg(ms), latency_pct(ms), latency_max(ms), latency_sum(ms)")

   local seconds = stat.time_total
   local total = stat.reads+stat.writes+stat.other
   print(string.format("%4.0f, %u, " .. "%u, %u, %u, %u, " ..
                          "%u, %u, %u, %4.2f, %4.2f, %4.2f, " ..
                          "%u, %4.2f, " .. "%4.2f, %4.2f, %4.2f, %4.2f, %4.2f",
                       stat.time_total, stat.events,
                       stat.reads, stat.writes, stat.other, total,
                       stat.events, total, stat.errors,
                       stat.events/seconds, total/seconds, stat.errors/seconds,
                       stat.reconnects, stat.reconnects/seconds,
                       stat.latency_min * 1000, stat.latency_avg * 1000,
                       stat.latency_pct * 1000, stat.latency_max * 1000, stat.latency_sum * 1000
   ))
end

sysbench.hooks.report_cumulative = report_cumulative_csv


