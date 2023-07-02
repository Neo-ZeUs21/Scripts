#!/bin/bash
 
# Access the first argument passed to the script
url=$1

while :
do
    until youtube-dl -f 2 $url | grep -q "[download] 100% of"
    do
        echo "Waiting for Live...$url"
        sleep 60
    done

    echo "[download] 100% of $url.  Rerunning Loop..."
    # Add any additional actions you want to perform when the string is found
done
