#!/bin/bash

while :
do
    until youtube-dl -f 2 https:// | grep -q "[download] 100% of"
    do
        echo "Waiting for Live..."
        sleep 60
    done

    echo "Downloaded. Restarting Monitor..."
    # Add any additional actions you want to perform when the string is found
done 
