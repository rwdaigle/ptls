process.env.NODE_ENV = 'test';

var Browser = require('zombie'),
  assert = require('assert'),
  app = require('../app');

app.listen(3001);
var browser = new Browser({debug: false, loadCSS: false, site: 'http://localhost:3001'});

var responseHelper = require('./helpers/response')

exports.assertStatus = function(code) {
  return function (err, browser, status) {
    assert.equal(status, code);
  }
}

exports.browser = browser;