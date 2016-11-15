#!/usr/bin/bash
# file "disabled" 
# - exists: continue execution
# - does not exist: exit


ROOT=$(dirname `readlink -f $0`)
if [[ -f $ROOT/disabled ]]; then 
	echo "==> Shutdown allowed (module is disabled)"
	exit 0
else
	echo "==> Shutdown NOT allowed (module is active)"
	exit 1
fi 
