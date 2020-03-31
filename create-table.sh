#!/bin/bash

CH_HOME="/home/wangfenjin/gocode/src/code.byted.org/dp/ClickHouse/"

cat ch-tpcds.sql | ${CH_HOME}/build/dbms/programs/clickhouse client --port=9001 -mn
