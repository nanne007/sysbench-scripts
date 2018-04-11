. ./conf.sh


sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=1 \
         --events=$events --time=$time \
         --number_of_ranges=${number_of_ranges:-10} --delta=${delta:-100} \
         src/lua/select_random_ranges.lua run
