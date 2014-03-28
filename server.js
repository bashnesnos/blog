var connect = require('connect');
connect.createServer(
    connect.static('build/jbake')
).listen(8080);