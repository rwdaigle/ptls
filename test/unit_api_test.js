var vows = require('vows'),
  assert = require('assert'),
  test = require('./test_helper');

vows.describe('Unauthorized unit API requests').addBatch({

  'to /units': {
    topic: function() { test.browser.visit('/units', this.callback); },
    'should respond with a 401': test.assertStatus(401)
  },

  // 'to /units/:id': {
  //   topic: function() { browser.visit('/units', this.callback); },
  //   'should respond with a 401': responseHelper.assertStatus(401)
  // }

}).export(module);