module.exports = function(app) {

	var models = require('../helpers/models');

	// Units
	var unitsController = require('../controllers/units'),
		Unit = require('../models/unit');
	app.param('unitId', models.bind('unit', Unit.load));
	app.get('/units/:unitId.:format?', unitsController.show);
}