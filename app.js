var express = require('express'),
	resource = require('express-resource'),
	app = express.createServer();

require('./config/environment.js')(app, express);
require('./config/routes.js')(app, express);