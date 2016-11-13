#!/usr/bin/bash
# file "disabled" 
# - exists: continue execution
# - does not exist: exit


if [[ -f ./disabled ]]; then 
	echo "==> Shutdown allowed (Plugin is disabled)"
	exit 0
else
	echo "==> Shutdown NOT allowed (Plugin is active)"
	exit 1
fi 
	
