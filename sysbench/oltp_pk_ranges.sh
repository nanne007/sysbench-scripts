. ./conf.sh

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=$tables \
         --events=$events --time=$time \
         --skip_trx=${skip_trx:-off} \
         --range_size=${range_size:-100} \
         --$range_type=${range_num:-1} \
         src/lua/oltp_$range_type.lua run
