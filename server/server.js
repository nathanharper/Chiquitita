var exec = require('child_process').exec;
var id = process.argv[2] || 0;
var port = process.argv[3] || 12345;
var protocol = process.argv[4] || 'udp';
var ENABLED = ['x','z','s','a','return','rshift','up','down','left','right'];
var DIRS = ['up','down'];

protocol = protocol.toLowerCase();

if (protocol === 'udp') {
    require('dgram').createSocket('udp4').on("message", function(msg, rinfo) {
        var parts = msg.toString().split(' ');
        if (parts.length < 2) return;
        do_keys(parts[0], parts[1]);
    }).bind(port);
}
else if (protocol === 'http') {
    var io = require('socket.io');
    var fs = require('fs');
    var server = require('http').createServer(function(req, res) {
        fs.readFile(__dirname+'/index.html', 'utf8', function(err, data) {
            if (err) {
                res.writeHead(500, {"Content-Type": "text/plain"});
                res.write(err+"\n");
                res.end();
                return;
            }
            res.writeHead(200, {"Content-Type": "text/html"});
            res.end(data, 'utf8');
        });
    }).listen(port);

    var websocket = io.listen(server);
    websocket.sockets.on('connection', function(client) {
        client.on('key', function(data) {
            do_keys(data.key, data.action);
        });
    });
}
else {
    console.log('Accepted protocols: udp, http');
    process.exit(1);
}

function do_keys(key, action) {
    if (ENABLED.indexOf(key) < 0 || DIRS.indexOf(action) < 0) return;
    var command = "export DISPLAY=:0; xdotool key"+action+" --window "+id+" '"+firstUpper(key)+"'";
    exec(command)
}

function firstUpper(str) {
    if (str.length <= 1)
        return str.toUpperCase();
    return str.charAt(0).toUpperCase() + str.slice(1);
}
