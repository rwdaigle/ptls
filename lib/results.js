exports.first = function(callback) {
	return function(err, result) {
    errOrResultCallback(err, callback, function() { return result.rows[0]; });
	}
}

exports.all = function(callback) {
  return function(err, result) {
    errOrResultCallback(err, callback, function() { return result.rows; });
  }
}

exports.noOp = function(callback) {
  return function(err, result) {
    errOrResultCallback(err, callback, function() { return null; });
  }
}

exports.getRowOnCreate = function(onErr, onSuccess) {
  return function(err, result) {
    if(err) {
      console.error(err.message);
      onErr(err, null);
    } else {
      onSuccess();
    }
  }
}

var errOrResultCallback = function(err, callback, getResultValue) {
  if(err) {
    console.error(err.message);
    callback(err, null);
  } else {
    callback(null, getResultValue());
  }
}