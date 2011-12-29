module.exports = function(app) {

	app.param('unitId', function(req, res, next, id) {
		Unit.load(id, function(err, unit) {
			if (err) return next(err);
			if (!unit) return next(new Error('Failed to find unit with id: ' + id));
			req.model = unit;
			next();
		});
	});

	var models = require('../helpers/models');

	// Units
	var unitsController = require('../controllers/units'),
		unit = require('../models/unit');
	app.get('/units/:unitId.:format?', unitsController.show);
	// , models.setModel('unitId', unit.load)
}