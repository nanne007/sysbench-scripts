. ./conf.sh

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=$tables \
         --events=$events --time=$time \
         --auto_inc=${auto_inc:-on} \
         src/lua/oltp_insert.lua run
