#!/bin/bash
if [ -z "$1" ]; then
    echo "Path to SNES ROM file required."
    exit 1
fi

find_chrome() {
    if hash chromium 2>/dev/null; then
        chromium "$@"
    elif hash chromium-browser 2>/dev/null; then
        chromium-browser "$@"
    else
        echo "This script depends on Chromium browser :("
    fi
}

zsnes "$1" &
sleep 1
ZSNES_ID="$(xdotool search ZSNES|awk 'NR==1{print $1}')"
echo "ZSNES_ID is $ZSNES_ID"
node server/server.js "$ZSNES_ID" 12345 http &
SERVER_PID="$!"
find_chrome "http://localhost:12345"
echo "Server PID: $SERVER_PID"