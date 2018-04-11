. ./conf.sh

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --events=$events --time=$time \
         --table_size=$table_size --tables=$tables \
         --auto_inc=${auto_inc:-on} \
         --start_id=${start_id:-0} \
         --secondary_num=${secondary_num:-0} \
         src/lua/oltp_batch_insert.lua run
