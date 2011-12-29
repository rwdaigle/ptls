// Model-related loader functions

// Set the model for this request using the given parameter
// id and loader function
exports.setModel =  function(loadParam, load) {
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