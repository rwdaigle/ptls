var express = require('express');
var pg = require('pg');

var app = express.createServer(express.logger());
app.set('view engine', 'jade');

app.get('/', function(req, res) {
	pg.connect(process.env.DATABASE_URL, function(err, client) {

    var query = client.query('SELECT * FROM units ORDER BY ID LIMIT 20', function(err, result) {
      res.render('items', { items: result.rows });
    });

    // query.on('row', function(row) {
    //   console.log("Found result row for unit: " + row.id);
    //   res.write(row.id + ": " + row.question + " - " + row.answer + "<br/>");
    // });

    // query.on('end', function() {
    //   res.end();
    // })
  });
});

var port = process.env.PORT || 3000;
app.listen(port, function() {
  console.log("Listening on " + port);
});