#!/bin/bash

DIR="./queries"
CH_HOME="/home/wangfenjin/gocode/src/code.byted.org/dp/ClickHouse/"

ls $DIR/*.sql | while read file; do
    echo $file
    cat $file | ${CH_HOME}/build/dbms/programs/clickhouse client --port=9001 --database=tpcds1g -t -mn
done
