module.exports = function(app) {

	var setModel = function(loadParam, load) {
		return function(req, res, next) {
			load(req.params[loadParam], function(err, model) {
				if(model) {
					req.model = model;
					next();
				} else {
					next(err);
				}
			});
		}
	};

	// Units
	var unitsController = require('../controllers/units'),
		unit = require('../models/unit');
	app.get('/units/:id.:format?', setModel('id', unit.load), unitsController.show);
}