var Unit = require('../models/unit');

var sendResult = function(res) {
	return function(err, result) {
		if(err) throw err;
		res.send(result);
	};
};

exports.show = function(req, res) {
	Unit.load(req.param('unitId'), sendResult(res));
};

exports.index = function(req, res) {
	Unit.all(req.param('limit') || 10, sendResult(res));
};