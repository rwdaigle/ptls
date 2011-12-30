var vows = require('vows'),
  assert = require('assert'),
  test = require('./test_helper');

exports.suite1 = vows.describe('Unit API').addBatch({

  'Unit API requests': {
    'by an unauthorized user': {

      'to /units': {
        topic: function() { test.browser.visit('/units', this.callback); },
        'should respond with a 401': test.assertStatus(401)
      },

      'to /units/:id': {
        topic: function() { test.browser.visit('/units/1', this.callback); },
        'should respond with a 401': test.assertStatus(401)
      }
      
    },

    'by an authorized user': {

      'to /units': {
        topic: function() { test.browser.visit('/units', this.callback); },
        'should respond with a 200': test.assertStatus(200)
      }
    }
  }

});