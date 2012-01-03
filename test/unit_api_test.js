var vows = require('vows'),
  assert = require('assert'),
  test = require('./test_helper'),
  Faker = require ('Faker'),
  User = require('../models/user');

// User.create(Faker.Internet.userName(), 'password', Faker.Internet.email(), function(key) { console.log(key); });

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

      // Executes after every vow. We want to execute after suite (?)
      // tearDown: function(user) {
      //   User.destroy(user.id, function(err, theUser) { });
      // }
    }
  }

});