db_driver=${db_driver:-mysql}
mysql_db=${mysql_db:-sbtest}
mysql_host=127.0.0.1
mysql_port=4000
mysql_user=root
mysql_password=''

pgsql_host=127.0.0.1
pgsql_port=26257
pgsql_user=root
pgsql_password=''
pgsql_db=${pgsql_db:-sysbench}

conn_args=''
if [[ $db_driver = "mysql" ]];
then
    conn_args="$conn_args --db-driver=$db_driver"
    conn_args="$conn_args --mysql-host=$mysql_host --mysql-port=$mysql_port"
    conn_args="$conn_args --mysql-user=$mysql_user --mysql-password=$mysql_password"
    conn_args="$conn_args --mysql-db=$mysql_db"
else
    conn_args="$conn_args --db-driver=$db_driver"
    conn_args="$conn_args --pgsql-host=$pgsql_host --pgsql-port=$pgsql_port"
    conn_args="$conn_args --pgsql-user=$pgsql_user --pgsql-password=$pgsql_password"
    conn_args="$conn_args --pgsql-db=$pgsql_db"
fi

tables=${tables:-16}
table_size=${table_size:-100000000}
threads=${threads:-16}
report_interval=${report_interval:-2}
histogram=${histogram:-off}
events=${events:-0}
time=${time:-0}

simple_ranges=${simple_ranges:-1}
sum_ranges=${sum_ranges:-1}
order_ranges=${order_ranges:-1}
distinct_ranges=${distinct_ranges:-1}

