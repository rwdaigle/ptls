var db = require('../config/db'),
  results = require('../lib/results'),
  crypto = require('crypto');

exports.load = function(id, fn) {
  loadBy('id', id, fn);
  // console.info("Loading user by id: " + id);
  // db.query('SELECT * FROM users WHERE ID = $1', [id], results.first(fn));
};

var loadBy = exports.loadBy = function(col, value, fn) {
  console.info("Loading user by " + col + ": " + value);
  db.query('SELECT * FROM users WHERE ' + col + ' = $1', [value], results.first(fn));
};

exports.loadFromToken = function(token, fn) {
  console.info("Loading user from token");
  db.query('SELECT * FROM users WHERE token = $1', [token], results.first(fn));
};

// TODO: This callback hell has to go. If only returning id worked.
exports.create = function(login, password, email, fn) {
  console.info("Creating new user: " + email);
  generateCryptedPassword(email, password, function(salt, cryptedPassword) {
    db.query("INSERT INTO users(login, crypted_password, salt, email) VALUES($1, $2, $3, $4) RETURNING login", [login, cryptedPassword, salt, email], results.getRowOnCreate(fn, function() {
      loadBy('login', login, function(err, user) {
        fn(err, user);
      });
    }));
  });
}

exports.destroy = function(id, fn) {
  console.info("Destroying user with id: " + id);
  db.query("DELETE FROM users WHERE id = $1", [id], results.noOp(fn));
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