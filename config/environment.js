module.exports = function(app, express) {

	app.configure(function() {
		app.use(express.logger({ format: ':method :url :status in :response-time ms' }));
		app.use(express.static(__dirname + '/public'));
		app.use(express.bodyParser());
		app.use(express.cookieParser());
		app.use(require('connect-cookie-session')({ secret: process.env.SESSION_SECRET }));
		// app.use(express.session({ secret: process.env.SESSION_SECRET }));
		app.use(app.router);
	});

    app.configure('development', 'test', 'staging', function() {
	    app.use(express.errorHandler({
	        dumpExceptions: true,
	        showStack: true
	    }));
    });

    app.configure('production', function() {
    	app.use(express.errorHandler());
    });

	app.listen(process.env.PORT || 3000, function() {
	  console.log("PTLS web process started");
	});
};