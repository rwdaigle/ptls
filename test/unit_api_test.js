var vows = require('vows'),
  assert = require('assert'),
  test = require('./test_helper'),
  Faker = require ('Faker'),
  User = require('../models/user');

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

      topic: function() {
        User.create(Faker.Internet.userName(), 'password', Faker.Internet.email(), this.callback);
      },

      'to /units?token=XYZ': {
        topic: function(user) {
          test.browser.visit('/units?token=' + user.token, this.callback);
        },
        'should respond with a 200': test.assertStatus(200)
      },

      'to /units/X?token=Y': {
        topic: function(user) {
          test.browser.visit('/units/2000?token=' + user.token, this.callback);
        },
        'should respond with a 200': test.assertStatus(200)
      },

      // Executes before vows complete since their execution is asynchronous.
      // TODO: Quite sure this isn't the right way to wait for vows to complete.
      tearDown: function(user) {
        setTimeout(50, function() {
          User.destroy(user.id, function(err, theUser) { })
        });
      }
    }
  }

});