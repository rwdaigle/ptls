module.exports = function(app) {

	// var models = require('../filters/models');
	var auth = require('../middleware/auth');
	var authenticationRequiredStack = [auth.loadAuthenticatedUser];

	// Units
	var unitsController = require('../controllers/units');
		// Unit = require('../models/unit');
	// app.param('unitId', models.bind('unit', Unit.load));
	app.get('/units/:unitId.:format?', authenticationRequiredStack, unitsController.show);
	app.get('/units.:format?', authenticationRequiredStack, unitsController.index);
}