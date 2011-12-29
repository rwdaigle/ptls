var db = require('../config/db');

exports.load = function(id, fn) {
  console.info("Loading user id: " + id);
  var query = db.query('SELECT * FROM users WHERE ID = $1', [id], function(err, result) {
    err ? fn(err, null) : fn(null, result.rows[0]);
  });
};