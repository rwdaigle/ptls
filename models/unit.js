var db = require('../config/db');

exports.load = function(id, fn) {
  console.info("Loading unit id: " + id);
  var query = db.query('SELECT * FROM units WHERE ID = $1', [id], function(err, result) {
    err ? fn(err, null) : fn(null, result.rows[0]);
  });
};

exports.all = function(limit, fn) {
  console.info("Loading " + limit + " units");
  var query = db.query('SELECT * FROM units LIMIT $1', [limit], function(err, result) {
    err ? fn(err, null) : fn(null, result.rows);
  });
};