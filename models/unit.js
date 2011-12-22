var config = require('../config');

exports.find = function(id, fn) {
  console.log("Retrieving unit id: " + id);
  var query = config.db.query('SELECT * FROM units WHERE ID = $1', [id], function(err, result) {
    err ? fn(err, null) : fn(null, result.rows[0]);
  });
};