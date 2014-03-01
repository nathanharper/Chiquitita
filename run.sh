#!/bin/bash
if [ -z "$1" ]; then
    echo "Path to SNES ROM file required."
    exit 1
fi
zsnes "$1" &
sleep 1
ZSNES_ID="$(xdotool search ZSNES|awk 'NR==1{print $1}')"
echo "ZSNES_ID is $ZSNES_ID"
node server/server.js "$ZSNES_ID" &
SERVER_PID="$!"
love controller
echo "Killing server by PID: $SERVER_PID"
kill -15 "$SERVER_PID"
