#!/usr/bin/bash
# Check if Tvheadend is recording
URL=localhost
PORT=9981
USERNAME=username
PASSWORD=password
OUTPUT=$(curl -u $USERNAME:$PASSWORD --silent --max-time 5 "http://$URL:$PORT/status.xml")
if [ -z "$OUTPUT" ]; then
        log "Tvheadend is not responding"
elif echo $OUTPUT | grep "<status>Recording</status>" > /dev/null; then
        log "Tvheadend is recording"
        cancel
elif ! echo $OUTPUT | grep "<subscriptions>0</subscriptions>" > /dev/null; then
        log "Tvheadend is active"
        cancel
fi


# Check when the next recording is sheduled
till=$(echo $OUTPUT | grep next |  sed -e 's,.*<next>\([^<]*\)</next>.*,\1,g')
if [ -z "${till##*[!0-9]*}" ]; then
        log "No recording sheduled"
elif [ $till -lt 90 ]; then
        log "Next recording starts in $till minutes. Doing nothing."
        cancel
fi