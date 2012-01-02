exports.first = function(callback) {
	return function(err, result) {
    handleErrOrResult(err, callback, function() { return result.rows[0]; });
	}
}

exports.all = function(callback) {
  return function(err, result) {
    handleErrOrResult(err, callback, function() { return result.rows; });
  }
}

exports.getIdOnCreate = function(callback) {
  return function(err, result) {
    handleErrOrResult(err, callback, function() { return result.rows[0].id; });
  }
}

var handleErrOrResult = function(err, callback, getResultValue) {
  if(err) {
    console.error(err.message);
    callback(err, null);
  } else {
    callback(null, getResultValue());
  }
}