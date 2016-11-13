#!$(which bash)

ROOT=$(dirname `readlink -f $0`)
LOGFILE="/tmp/shutdown-script.log"
STOPFILE=$ROOT/disabled 

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
}

# call modules
function call_modules() {
	# prehooks, plugins, posthooks
	MTYPE=$1
	# shutdown DS only if var is still zero in the end
	ALLOW_SHUTDOWN=0
	for d in $(ls -d $MTYPE/* ); do 
		module=$( basename $d | sed -e 's/\///' )
		# skip the module if disabled 
		[[ -f $MTYPE/$module/disabled ]] && log "- module $module: ###disabled###" && continue
		log "- module $module: Starting..."
		pushd $MTYPE/$module > /dev/null
		./start.sh 
		let "ALLOW_SHUTDOWN=$ALLOW_SHUTDOWN+$?"
		popd > /dev/null
	done
	log "Result: $ALLOW_SHUTDOWN"
	return $ALLOW_SHUTDOWN
}

function godown() {
	log "+++ Shutting off the system in 5 seconds! "
	sleep 5
	/sbin/poweroff
}

main
