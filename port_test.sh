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
        echo -e port: $u server: $SERVER = "\033[31m" closed "\033[m"
    else
        echo -e port: $u server: $SERVER = "\033[34m" open "\033[m"
    fi
done
