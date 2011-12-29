module.exports = function(app) {

	var models = require('../helpers/models');

	// Units
	var unitsController = require('../controllers/units'),
		unit = require('../models/unit');
	app.get('/units/:id.:format?', models.setModel('id', unit.load), unitsController.show);
}