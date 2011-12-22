var express = require('express'),
  resource = require('express-resource'),
  app = express.createServer(express.logger());

var Unit = require('./models/unit')
app.resource('units', require('./controllers/units_controller'), { load: Unit.find });

app.listen(process.env.PORT || 3000, function() {
  console.log("PTLS web process started");
});