var db = require('../config/db');

exports.up = function(next) {
	db.query("ALTER TABLE users ADD COLUMN token varchar(255) DEFAULT md5(CAST(RANDOM() as text) || NOW())", function(err, result) {
		db.query("CREATE UNIQUE INDEX index_users_on_token ON users (token)", function(err, result) {
			db.query("UPDATE users SET token = md5(salt || email || login || created_at || NOW()) WHERE token IS NULL", function(err, result) {
				next();
			});
		});
	});
};

exports.down = function(next){
	db.query("ALTER TABLE users DROP COLUMN token", function(err, result) {
		next();
	});
};
