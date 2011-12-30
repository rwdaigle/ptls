var express = require('express');
var	app = module.exports = express.createServer();

require('./config/environment.js')(app, express);
require('./config/routes.js')(app);

// Only listen on $ node app.js (not on testing etc...)
if (!module.parent) {
  app.listen(process.env.PORT || 3000, function() {
    console.log("PTLS web process started");
  });
}