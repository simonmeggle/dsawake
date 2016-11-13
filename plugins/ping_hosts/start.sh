#!/usr/bin/bash
# Ping a list of hosts in hosts.txt (name;ip)
# increment the return code for every host which is still up. 

HOSTFILE=hosts.txt
AWAKE=0

if [ ! -r $HOSTFILE ]; then 
	echo "ERROR: Host file $HOSTFILE cannot be read."
	exit 1
fi

# (read the last line regardless of a newline char)
while read LINE || [[ -n $LINE ]]; do 
	HOST=$(echo $LINE | cut -d ';' -f 1)
	IP=$(echo $LINE | cut -d ';' -f 2)
	[ -z $IP ] && continue
	echo -n "$HOST ($IP) is "
	ping -n 1 -w 1000 $IP > /dev/null	
	# if host is up, increment AWAKE
	if [[ $? -eq 0 ]]; then 
		echo "up."
		((AWAKE++))
	else
		echo "down."
	fi 
done < $HOSTFILE

echo "$AWAKE hosts are up."
exit $AWAKE