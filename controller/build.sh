#!/bin/bash
zip -9 -q -r TwitchController.love .
cat "$LOVE_BIN/love.exe" TwitchController.love > TwitchController.exe
cat `which love` TwitchController.love > TwitchControllerLinux
chmod a+x TwitchControllerLinux
