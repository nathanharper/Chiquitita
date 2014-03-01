var exec = require('child_process').exec;
var id = process.argv[2] || 0;
var port = process.argv[3] || 12345;

var ENABLED = ['x','z','s','a','return','rshift','up','down','left','right'];
var DIRS = ['up','down'];

require('dgram').createSocket('udp4').on("message", function(msg, rinfo) {
    var parts = msg.toString().split(' ');
    if (parts.length < 2) return;
    var key = parts[0];
    var action = parts[1];
    if (ENABLED.indexOf(key) < 0 || DIRS.indexOf(action) < 0) return;
    key = firstUpper(key);
    var command = "export DISPLAY=:0; xdotool key"+action+" --window "+id+" '"+key+"'";
    console.log(command);
    exec(command)
}).bind(port);

function firstUpper(str) {
    if (str.length <= 1)
        return str.toUpperCase();
    return str.charAt(0).toUpperCase() + str.slice(1);
}
