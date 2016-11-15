#!/bin/bash
#title           :ds_awake.sh
#description     :a modular script to keep Synology Diskstation (or any other s
#                 bashable system running as long as all plugins are returning a
#                 rc > 0. Disable plugins simply by putting a file "disabled" into
#                 the plugin folder. Use pre/host hooks to execute additional 
#                 tasks. Prehooks are able to interrupt the script. 
#author		     :Simon Meggle 
#date            :20161115
#version         :0.1
#usage		     :bash ds_awake.sh
#==============================================================================

ROOT=$(dirname `readlink -f $0`)
LOGFILE="/var/log/$(basename $0).log"

export ORANGE='\033[0;33m'

log() {
        echo `date +%c` $1 | tee -a $LOGFILE
}

function main() {
	cd $ROOT
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
	echo $ALLOW_SHUTDOWN
	if [ ! -d $ROOT/$MTYPE ]; then 
		log "ERROR: $ROOT/$MTYPE does not exist. Exiting."
		exit 1
	fi 
	for d in $(ls -d $ROOT/$MTYPE/* ); do 
		module=$( basename $d | sed -e 's/\///' )
		# skip the module if disabled 
		[[ -f $MTYPE/$module/disabled ]] && log "$ALLOW_SHUTDOWN - module $module: ###disabled###" && continue
		if [ -r $MTYPE/$module/start.sh ]; then 
			log "$ALLOW_SHUTDOWN - module $module: Starting..."
			# evaluate return code of start.sh, not tee
			set -o pipefail
			bash $MTYPE/$module/start.sh | tee -a $LOGFILE 
			let "ALLOW_SHUTDOWN=$ALLOW_SHUTDOWN+$?"
			set +o pipefail
		else
			let "ALLOW_SHUTDOWN=$ALLOW_SHUTDOWN+1"
			log "ERROR: $MTYPE/$module/start.sh could not be found!"
		fi
	done
	log "$MTYPE result: $ALLOW_SHUTDOWN"
	return $ALLOW_SHUTDOWN
}

function godown() {
	log "+++ Shutting down the system in 5 seconds! "
	sleep 5
	#/sbin/poweroff
}

main
log "----- Keeping this Diskstation powered on."
log "===== END =============="
