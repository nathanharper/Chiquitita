<h1>Chiquitita</h1>

Inspired by "TwitchPlaysPokemon", this is a way to play a remote SNES emulator via a web interface. Invite your friends to join in and try to play the game at the same time, resulting in much confusion and anguish. Screencast the game for even more fun!


<h3>Install and Run</h3>
<hr />

This command will start up the zsnes emulator and start a server at http://localhost:12345. You can theoretically use other snes emulators, or basically anything that runs in an X window. Should work on Linux and Mac, though dependency installation method will obviously vary.

<pre>
sudo apt-get install nodejs npm zsnes xdotool
npm install
./run_http.sh super_mario.smc
</pre>

To just start the server with ZSNES already running, do (replacing [PORT] with the port to run the server on):

<pre>node server/server.js "$(xdotool search ZSNES|awk 'NR==1{print $1}')" [PORT] http</pre>

Non-default key-mappings aren't really supported right now :((((((((((


<h3>Special Thanks</h3>
<hr />

I yoinked the wonderful HTML/CSS snes controller from <a href="http://codepen.io/TimPietrusky/pen/oJIcy">Tim Pietrusky on Codepen</a>!
