var User = require('../models/User');

exports.loadAuthenticatedUser = function(req, res, next) {
	var userId = req.session.userId;
	if(userId) {
		User.load(userId, function(err, user) {
			req.authenticatedUser = user ? user : null;
			next();
		});
	} else {
		next();
	}
}

exports.loadTokenizedUser = function(req, res, next) {
	var token = req.param('token');
	if(token) {
		User.loadFromToken(token, function(err, user) {
			req.authenticatedUser = user ? user : null;
			next();
		});
	} else {
		next();
	}
}