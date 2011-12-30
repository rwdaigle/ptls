var db = require('../config/db'),
  results = require('../lib/results'),
  crypto = require('crypto');

exports.load = function(id, fn) {
  console.info("Loading user id: " + id);
  db.query('SELECT * FROM users WHERE ID = $1', [id], results.first(fn));
};

exports.loadFromToken = function(token, fn) {
  console.info("Loading user from token");
  db.query('SELECT * FROM users WHERE token = $1', [token], results.first(fn));
};

exports.create = function(login, password, email, fn) {
  console.info("Creating new user: " + email);
  generateCryptedPassword(email, password, function(salt, cryptedPassword) {
    db.query("INSERT INTO users(login, crypted_password, salt, email) VALUES($1, $2, $3, $4, $5) RETURNING id", [login, cryptedPassword, salt, email], results.getIdOnCreate);
  });
}

var generateCryptedPassword = function(email, password, callback) {
  var salt = crypto.createHash('sha1').update(Date.now() + ':' + email).digest('hex');
  encryptPassword(salt, password, function(cryptedPassword) {
    callback(salt, cryptedPassword);
  })
};

var encryptPassword = function(salt, password, callback) {
  callback(crypto.createHash('sha1').update(salt + ':' + password).digest('hex'));
}