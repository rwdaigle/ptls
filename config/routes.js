module.exports = function(app, express) {

	var Unit = require('../models/unit')
	app.resource('units', require('../controllers/units_controller'), { load: Unit.find });
}