var envSuffix = process.env['NODE_ENV'] ? '_' + process.env['NODE_ENV'].toLowerCase() : null;
var pg = require('pg');
var client = new pg.Client(process.env.DATABASE_URL || "postgres://root:@localhost/ptls" + envSuffix );
client.connect();
module.exports = client;