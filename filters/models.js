// Model-related loader functions

// Set the model for this request using the given parameter
// id and loader function
exports.setModel = function(loadParam, load) {
	return function(req, res, next) {
		load(req.params[loadParam], function(err, model) {
			if(model) {
				req.model = model;
				next();
			} else {
				next(err);
			}
		});
	}
};

exports.bind = function(name, loadFn) {
	return function(req, res, next, id) {
		loadFn(id, function(err, model) {
			if (err) return next(err);
			if (!model) return next(new Error('Failed to find ' + name + ' with value: ' + id));
			req[name] = model;
			next();
		});
	};
}