#!/bin/bash

ROOT=$(dirname `readlink -f $0`)
LOGFILE="/var/log/$(basename $0).log"

export ORANGE='\033[0;33m'

log() {
        echo `date +%c` $1 | tee -a $LOGFILE
}

function main() {
	log "===== START $(basename $0) ====="
	log "----- Calling pre-hooks"
	call_modules prehooks || return 
	log "----- Calling plugins"
	call_modules plugins || return 
	log "----- Calling post-hooks"
	call_modules posthooks
	log "----- Shutdown."
	godown
	exit 0
}

# call modules
function call_modules() {
	# prehooks, plugins, posthooks
	MTYPE=$1
	# shutdown DS only if var is still zero in the end
	ALLOW_SHUTDOWN=0
	if [ ! -d $ROOT/$MTYPE ]; then 
		log "ERROR: $ROOT/$MTYPE does not exist. Exiting."
		exit 1
	fi 
	for d in $(ls -d $ROOT/$MTYPE/* ); do 
		module=$( basename $d | sed -e 's/\///' )
		# skip the module if disabled 
		[[ -f $MTYPE/$module/disabled ]] && log "$ALLOW_SHUTDOWN - module $module: ###disabled###" && continue
		log "$ALLOW_SHUTDOWN - module $module: Starting..."
		pushd $MTYPE/$module > /dev/null
		bash start.sh 
		let "ALLOW_SHUTDOWN=$ALLOW_SHUTDOWN+$?"
		popd > /dev/null
	done
	log "$MTYPE result: $ALLOW_SHUTDOWN"
	return $ALLOW_SHUTDOWN
}

function godown() {
	log "+++ Shutting down the system in 5 seconds! "
	sleep 5
	/sbin/poweroff
}

main
log "----- Keeping this Diskstation powered on."
log "===== END =============="
