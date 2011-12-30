var db = require('../config/db');
var results = require('../lib/results');

exports.load = function(id, fn) {
  console.info("Loading unit id: " + id);
  db.query('SELECT * FROM units WHERE ID = $1', [id], results.first(fn));
};

exports.all = function(limit, fn) {
  console.info("Loading " + limit + " units");
  db.query('SELECT * FROM units LIMIT $1', [limit], results.all(fn));
};