var db = require('../config/db');

exports.load = function(id, fn) {
  console.log("Loading unit id: " + id);
  var query = db.query('SELECT * FROM units WHERE ID = $1', [id], function(err, result) {
    err ? fn(err, null) : fn(null, result.rows[0]);
  });
};