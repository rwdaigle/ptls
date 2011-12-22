var express = require('express'),
  resource = require('express-resource'),
  app = express.createServer(express.logger());

app.resource('units', require('./controllers/unit'));

app.listen(process.env.PORT || 3000, function() {
  console.log("PTLS web process started");
});