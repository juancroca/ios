/*
A small NodeJS server that listens on port 8080.

Helps in debugging what the Rails server sends to the assignment algorithm.

Before running the Rails server, point the environment variables to this server:
export SCALA_PORT_8080_TCP_ADDR='localhost'
export SCALA_PORT_8080_TCP_PORT=8080
*/

// Load the http module to create an http server.
var http = require('http');

// Configure our HTTP server to respond with Hello World to all requests.
var server = http.createServer(function (request, response) {
	debugger;
});

// Listen on port 8080, IP defaults to 127.0.0.1
server.listen(8080);

// Put a friendly message on the terminal
console.log("Server running at http://127.0.0.1:8080/");
