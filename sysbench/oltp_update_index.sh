. ./conf.sh

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=${tables:-1} \
         --events=$events --time=${time:-3600} \
         src/lua/oltp_update_index.lua run
