const express = require('express');
const app = express();
const path = require('path');
const port = 3000;

// sendFile will go here
app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, '/index.html'));
  });

app.get('/joyplot_languages.html', function(req, res) {
  res.sendFile(path.join(__dirname, '/joyplot_languages.html'));
});

app.get('/coding_language_history.csv', function(req, res) {
  res.sendFile(path.join(__dirname, '/coding_language_history.csv'));
});

app.listen(port, () => {
  console.log(`Listening on http://localhost:${port}`);
});