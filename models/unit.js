var db = require('../config/db');

exports.find = function(id, fn) {
  console.log("Retrieving unit id: " + id);
  var query = db.query('SELECT * FROM units WHERE ID = $1', [id], function(err, result) {
    err ? fn(err, null) : fn(null, result.rows[0]);
  });
};

exports.default = function(req, res){
 	res.send('Unsupported format "' + req.format + '". Only JSON is supported, please append ".json" to the request.', 406);
 };