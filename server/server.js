var exec = require('child_process').exec;
var id = process.argv[2] || 92274691;

require('dgram').createSocket('udp4').on("message", function(msg, rinfo) {
        var str = msg.toString();
        var parts = str.split(' ').map(function(val) {
            // CLI escaping could be better...
            return val.replace("'", "'\"'\"'");
        });
        var key = firstUpper(parts[0]);
        var action = parts[1];
        var command;
        console.log(str);
        if (action == 'press') {
            command = "xdotool key --window "+id+" '"+key+"'";
        }
        else {
            command = "xdotool key"+action+" --window "+id+" '"+key+"'";
        }
	command = "export DISPLAY=:0; " + command;
        console.log(command);
        exec(command)
}).bind(12345);

function firstUpper(str) {
    if (str.length <= 1) {
        return str.toUpperCase();
    }
    return str.charAt(0).toUpperCase() + str.slice(1);
}
