#!/usr/bin/bash
# Check if synolocalbkp is running
if [ "$(pidof synolocalbkp)" ]; then
        log "Backup is running"
        cancel
fi