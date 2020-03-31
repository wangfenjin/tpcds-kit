#!/bin/bash

COUNTER=1
while [ $COUNTER -lt 100 ]
do
    echo 'define _END = "";' >> query$COUNTER.tpl
    COUNTER=`expr $COUNTER + 1`
done

echo "finish update query"
