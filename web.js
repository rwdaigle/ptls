var express = require('express'),
	resource = require('express-resource');
var	app = express.createServer(
	express.logger({ format: ':method :url :status in :response-time ms' }),
	express.bodyParser()
);

var Unit = require('./models/unit')
app.resource('units', require('./controllers/units_controller'), { load: Unit.find });

app.listen(process.env.PORT || 3000, function() {
  console.log("PTLS web process started");
});