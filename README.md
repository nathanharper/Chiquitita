<h1>Twitch Controller</h1>

This is some dirty hackery to get a "TwitchPlaysPokemon" type server running for the Zsnes emulator on Linux.

<pre>
sudo apt-get install nodejs zsnes love xdotool npm
./run.sh super_mario.smc
</pre>

To try the HTTP/Socket.io version:

<pre>
npm install
./run_http.sh super_mario.smc
</pre>
