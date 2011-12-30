exports.first = function(callback) {
	return function(err, result) {
		err ? callback(err, null) : callback(null, result.rows[0]);
	}
}

exports.all = function(callback) {
  return function(err, result) {
    err ? callback(err, null) : callback(null, result.rows);
  }
}