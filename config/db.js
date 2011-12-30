var pg = require('pg');
var client = new pg.Client(process.env.DATABASE_URL || "postgres://root:@localhost/ptls");
client.connect();
module.exports = client;