#! /bin/bash

while true
do
    # getting bytes downloaded since start
    RX_BYTES=$(ifconfig | grep bytes | grep RX | cut -d ':' -f 2 | cut -d ' ' -f 1 | awk '{s+=$1} END {print s}')
    # getting bytes uploaded since start
    TX_BYTES=$(ifconfig | grep bytes | grep TX | cut -d ':' -f 3 | cut -d ' ' -f 1 | awk '{s+=$1} END {print s}')
    # DOWNLOAD
    # verifying if file exists
    if [ -e /tmp/RX_BYTES ]
    then
        # previously total
        typeset -i RX_BYTES_OLD=$(cat /tmp/RX_BYTES)
        # delta = now minus 1 second ago
        RX_BYTES_DELTA="$((RX_BYTES - RX_BYTES_OLD))"
        # saving new total
        echo $RX_BYTES > /tmp/RX_BYTES
        # saving delta
        echo $RX_BYTES_DELTA > /tmp/RX_BYTES_DELTA
    else
        # if previously doesnt exist, delta will be zero
        RX_BYTES_OLD=$RX_BYTES
        RX_BYTES_DELTA="$((RX_BYTES - RX_BYTES_OLD))"
        echo $RX_BYTES > /tmp/RX_BYTES
        echo $RX_BYTES_DELTA > /tmp/RX_BYTES_DELTA
    fi
    # UPLOAD
    if [ -e /tmp/TX_BYTES ]
    then
        typeset -i TX_BYTES_OLD=$(cat /tmp/TX_BYTES)
        TX_BYTES_DELTA="$((TX_BYTES - TX_BYTES_OLD))"
        echo $TX_BYTES > /tmp/TX_BYTES
        echo $TX_BYTES_DELTA > /tmp/TX_BYTES_DELTA
    else
        TX_BYTES_OLD=$TX_BYTES
        TX_BYTES_DELTA="$((TX_BYTES - TX_BYTES_OLD))"
        echo $TX_BYTES > /tmp/TX_BYTES
        echo $TX_BYTES_DELTA > /tmp/TX_BYTES_DELTA
    fi
    # 1 second metric
    sleep 1
done
