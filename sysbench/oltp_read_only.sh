. ./conf.sh

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=$tables \
         --events=$events --time=$time \
         --range_selects=${range_selects:-on} --skip_trx=${skip_trx:-off} \
         --range_size=${range_size:-100} \
         --simple_ranges=${simple_ranges:-1} \
         --sum_ranges=${sum_ranges:-1} \
         --order_ranges=${order_ranges:-1} \
         --distinct_ranges=${distinct_ranges:-1} \
         src/lua/oltp_read_only.lua run
