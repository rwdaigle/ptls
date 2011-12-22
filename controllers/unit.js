var config = require('../config');

exports.show = function(req, res) {
	console.log("Retrieving unit id: " + req.params.unit);
  var query = config.db.query('SELECT * FROM units WHERE ID = ' + req.params.unit, function(err, result) {
    res.send(err || result.rows[0]);
  });
};