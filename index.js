const express = require('express');
const app = express();
const path = require('path');
const port = 3000;

// sendFile will go here
var static = require('node-static');
var http = require('http');

var file = new(static.Server)(__dirname);

//Serve all static files in this folder
http.createServer(function (req, res) {
  file.serve(req, res);
}).listen(8080);
