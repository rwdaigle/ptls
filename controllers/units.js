var Unit = require('../models/unit');

exports.show = function(req, res) {
 	res.send(req.unit);
};

exports.index = function(req, res) {
	Unit.all(req.param('limit') || 10, function(err, results) {
		if(err) throw err;
		res.send(results);
	});
};