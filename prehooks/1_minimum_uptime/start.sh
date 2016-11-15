#!/usr/bin/bash

# stay powered on for at least 30 minutes
minuptime=30

uptime=$(cat /proc/uptime)
uptime=${uptime%%.*}
minutes=$(( uptime/60 ))
if [ $minutes -lt $minuptime ]; then
        echo "=> Online since only $minutes minutes (at least $minuptime. Preventing shutdown.)"
        exit 1
else 
        echo "=> Online since $minutes minutes (at least $minuptime)."
		exit 0
fi
