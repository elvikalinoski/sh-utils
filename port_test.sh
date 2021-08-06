#!/bin/bash

#Server IP arguments; ./port_test.sh 127.0.0.1
SERVER=$1
#Add ports in array
PORT=( 80 443 8080 )

for u in "${PORT[@]}"  
do
    nc -z -v $SERVER $u &> /dev/null
    result1=$?

    if [  "$result1" != 0 ]; then
        echo port: $u server: $SERVER = closed
    else
        echo port: $u server: $SERVER = open
    fi
done