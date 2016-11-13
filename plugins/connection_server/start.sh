#!/usr/bin/bash
# Check if there is a connection via Webinterface or in of the Apps
if netstat | grep 'fozzie:https\|fozzie:5000\|fozzie:5001\|fozzie:5006' | grep ESTABLISHED > /dev/null; then
        log "Active connection to HTTPS, WebDAV or other DSM App"
        cancel
fi