#!/usr/bin/bash
# Check if one of the ACTIVEHOSTS has an open connection
ACTIVEHOSTS=""
for host in $ACTIVEHOSTS ; do
        if netstat -n | grep ' '$host':.*ESTABLISHED' > /dev/null; then
                log "$host currently accessing NAS"
                cancel
        fi
done