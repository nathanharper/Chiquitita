var exec = require('child_process').exec;
var id = process.argv[2] || 92274691;

require('net').createServer(function (socket) {
    // TODO: can we get IP from this?
    socket.on('data', function(data) {
        var str = data.toString();
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
        console.log(command);
        exec(command)
    });
}).listen(12345);

function firstUpper(str) {
    if (str.length <= 1) {
        return str.toUpperCase();
    }
    return str.charAt(0).toUpperCase() + str.slice(1);
}
