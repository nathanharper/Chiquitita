#!/bin/bash
if [ -z "$1" ]; then
    echo "Path to SNES ROM file required."
    exit 1
fi

export DISPLAY=:0
URL="http://localhost:12345"

find_chrome() {
    if hash chromium 2>/dev/null; then
        chromium "$@"
    elif hash chromium-browser 2>/dev/null; then
        chromium-browser "$@"
    else
        echo "Opening '$URL' with default browser."
        xdg-open "$URL"
    fi
}

zsnes "$1" &
sleep 1
ZSNES_ID="$(xdotool search --class ZSNES|awk 'NR==1{print $1}')"
echo "ZSNES_ID is $ZSNES_ID"
node server/server.js "$ZSNES_ID" 12345 http &
SERVER_PID="$!"
find_chrome "$URL"
echo "Server PID: $SERVER_PID"
