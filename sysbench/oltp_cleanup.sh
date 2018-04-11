. ./conf.sh


if [[ $db_driver = "mysql" ]];
then
    if [[ ${mysql_password} = "" ]];
    then
        mysql -h ${mysql_host} -P ${mysql_port} -u${mysql_user} -e "CREATE DATABASE IF NOT EXISTS ${mysql_db}"
    else
        mysql -h ${mysql_host} -P ${mysql_port} -u${mysql_user} -p{$mysql_password} -e "CREATE DATABASE IF NOT EXISTS ${mysql_db}"
    fi
fi

sysbench $conn_args \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --tables=$tables \
         src/lua/oltp_common.lua cleanup

