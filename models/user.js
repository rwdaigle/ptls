var db = require('../config/db');
var results = require('../lib/results');

exports.load = function(id, fn) {
  console.info("Loading user id: " + id);
  db.query('SELECT * FROM users WHERE ID = $1', [id], results.first(fn));
};

exports.loadFromToken = function(token, fn) {
  console.info("Loading user from token");
  db.query('SELECT * FROM users WHERE token = $1', [token], results.first(fn));
};