. ./conf.sh


if [[ $db_driver = "mysql" ]];
then
if [[ ${mysql_password} = "" ]];
then
    mysql -h ${mysql_host} -P ${mysql_port} -u${mysql_user} -e "CREATE DATABASE IF NOT EXISTS ${mysql_db}"
else
    mysql -h ${mysql_host} -P ${mysql_port} -u${mysql_user} -p{$mysql_password} -e "CREATE DATABASE IF NOT EXISTS ${mysql_db}"
fi
sysbench --db-driver=$db_driver \
         --mysql-host=$mysql_host --mysql-port=$mysql_port \
         --mysql-user=$mysql_user --mysql-password=$mysql_password --mysql-db=$mysql_db \
         --threads=$threads  --report-interval=$report_interval --histogram=$histogram \
         --table_size=$table_size --tables=$tables \
         /usr/share/sysbench/oltp_common.lua prepare

