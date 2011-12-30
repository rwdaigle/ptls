process.env.NODE_ENV = 'test';

var vows = require('vows'),
  assert = require('assert'),
  Browser = require('zombie'),
  app = require('../app');

app.listen(3001);
var browser = new Browser({debug: false, loadCSS: false, site: 'http://localhost:3001'});

var assertStatus = function(code) {
  return function (err, browser, status) {
    assert.equal(status, code);
  }
}

vows.describe('Unauthorized unit API requests').addBatch({

  'to /units': {
    topic: function() { browser.visit('/units', this.callback); },
    'should respond with a 401': assertStatus(401)
  }

}).export(module);