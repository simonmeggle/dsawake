#!/usr/bin/bash
# Check if transmission is downloading
USER=username
PASSWORD=password
TRANSMISSION="/usr/local/transmission/bin/transmission-remote --auth "$USER":"$PASSWORD
if $TRANSMISSION -l | grep 'Downloading\|Up & Down' > /dev/null; then
        log "Transmission currently downloading"
        cancel
fi