#!/bin/bash

# Create users and databases
function initialize_bpms_database {

  echo "Creating BPMS databases..."  

mysql $mysql_flags <<EOSQL
    GRANT ALL ON *.* TO 'jboss'@'localhost' IDENTIFIED BY 'jboss';
    GRANT ALL ON *.* TO 'jboss'@'%' IDENTIFIED BY 'jboss';
    CREATE DATABASE IF NOT EXISTS bpmsdesign;
    CREATE DATABASE IF NOT EXISTS bpmstest;
    CREATE DATABASE IF NOT EXISTS bpmsqa;
    CREATE DATABASE IF NOT EXISTS bpmsprod;
EOSQL

  mysql $mysql_flags bpmsdesign < /sql/mysql5-jbpm-schema.sql
  mysql $mysql_flags bpmsdesign < /sql/quartz_tables_mysql.sql
  mysql $mysql_flags bpmsdesign < /sql/mysql5-dashbuilder-schema.sql

  mysql $mysql_flags bpmstest < /sql/mysql5-jbpm-schema.sql
  mysql $mysql_flags bpmstest < /sql/quartz_tables_mysql.sql
  mysql $mysql_flags bpmstest < /sql/mysql5-dashbuilder-schema.sql

  mysql $mysql_flags bpmsqa < /sql/mysql5-jbpm-schema.sql
  mysql $mysql_flags bpmsqa < /sql/quartz_tables_mysql.sql
  mysql $mysql_flags bpmsqa < /sql/mysql5-dashbuilder-schema.sql

  mysql $mysql_flags bpmsprod < /sql/mysql5-jbpm-schema.sql
  mysql $mysql_flags bpmsprod < /sql/quartz_tables_mysql.sql
  mysql $mysql_flags bpmsprod < /sql/mysql5-dashbuilder-schema.sql

}

