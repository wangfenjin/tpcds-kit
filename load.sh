#!/bin/bash

DIR=/tmp/tpcds-data
CH_HOME="/home/wangfenjin/gocode/src/code.byted.org/dp/ClickHouse/"

ls $DIR/*.dat | while read file; do
    table=`basename $file .dat | sed -e 's/_[0-9]_[0-9]//'`
    sql="insert into tpcds1g.${table} FORMAT CSV"
    echo $file $table $sql
    ${CH_HOME}/build/dbms/programs/clickhouse client --port=9001 \
              --format_csv_delimiter="|" --query "$sql" < $file
done
