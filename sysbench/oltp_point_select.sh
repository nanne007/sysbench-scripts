. ./conf.sh

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=$tables \
         --events=$events --time=$time \
         src/lua/oltp_point_select.lua run
