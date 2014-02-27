<h1>Twitch Controller</h1>

This is some dirty hackery to get a "TwitchPlaysPokemon" type server running for the Zsnes emulator on Linux.

`sudo apt-get install nodejs zsnes love xdotool`

`node server/server.js`

`love controller`


<h3>Disclaimer</h3>

Run this at your own risk! It is an extremely hacky proof of concept. The server component is basically accepting raw TCP packets and mashing parts of it into shell commands. Do not run this on a public network unless you want to get severely pwned.
