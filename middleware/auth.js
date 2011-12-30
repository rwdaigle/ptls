var User = require('../models/user');

var bindUser = function(req, key, load, next) {
	if(!req.authenticatedUser && key) {
		load(key, function(err, user) {
			req.authenticatedUser = user ? user : null;
			next();
		});
	} else {
		next();
	}
}

// From http://stackoverflow.com/questions/5951552/basic-http-authentication-in-node-js
var basicAuthentication = function(req, callback) {
	var header = req.headers['authorization'] || '',
		token = header.split(/\s+/).pop() || '',
		auth = new Buffer(token, 'base64').toString(),
		parts = auth.split(/:/),
		username = parts[0],
		password = parts[1];
	callback(username, password);
}

exports.loadAuthenticatedUser = function(req, res, next) {
	bindUser(req, req.session.userId, User.load, next);
}

exports.loadTokenizedUser = function(req, res, next) {
	basicAuthentication(req, function(username, password) {
		bindUser(req, username || req.param('token'), User.loadFromToken, next);
	});	
}

exports.requireAuthenticatedUser = function(req, res, next) {
	if(req.authenticatedUser) {
		next();
	} else {
		res.send('Unauthorized access to protected resource', 401);
	}
}