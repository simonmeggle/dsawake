#!/bin/bash
# Checks for established connections on a specific port. 

PORTFILE=ports.txt
AWAKE=0

if [ ! -r $PORTFILE ]; then
    echo "ERROR: Port file $PORTFILE cannot be read."
	exit 1
fi

# (read the last line regardless of a newline char)
while read PORT || [[ -n $LINE ]]; do
    [ -z $PORT ] && continue
	netstat -ten | grep -e ":$PORT.*ESTABLISHED" 
    # if any connection found, increment AWAKE
    if [[ $? -eq 0 ]]; then
        ((AWAKE++))
   fi 
done < $PORTFILE

