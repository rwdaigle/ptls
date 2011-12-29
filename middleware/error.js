module.export = function (err, req, res, next) {
 	console.error(err.stack);
 	res.send(500);
}