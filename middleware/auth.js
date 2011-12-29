var User = require('../models/User');

exports.loadAuthenticatedUser = function(req, res, next) {
	var userId = req.session.userId;
	console.info('Loading authenticated user with id: ' + req.session.userId);
	if(userId) {
		User.load(userId, function(err, user) {
			req.authenticatedUser = user ? user : null;
			next();
		});
	} else {
		next();
	}
}