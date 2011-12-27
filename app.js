var express = require('express'),
	app = express.createServer();

require('./config/environment.js')(app, express);
require('./config/routes.js')(app);