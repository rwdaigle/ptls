# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

# Old
# # This file is copied to ~/spec when you run 'ruby script/generate rspec'
# # from the project root directory.
# ENV["RAILS_ENV"] = "test"
# require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
# require 'spec'
# require 'spec/rails'
#
# Spec::Runner.configure do |config|
#   # If you're not using ActiveRecord you should remove these
#   # lines, delete config/database.yml and disable :active_record
#   # in your config/boot.rb
#   config.use_transactional_fixtures = true
#   config.use_instantiated_fixtures  = false
#   config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

#   # == Fixtures
#   #
#   # You can declare fixtures for each example_group like this:
#   #   describe "...." do
#   #     fixtures :table_a, :table_b
#   #
#   # Alternatively, if you prefer to declare them only once, you can
#   # do so right here. Just uncomment the next line and replace the fixture
#   # names with your fixtures.
#   #
#   # config.global_fixtures = :table_a, :table_b
#   #
#   # If you declare global fixtures, be aware that they will be declared
#   # for all of your examples, even those that don't use them.
#   #
#   # == Mock Framework
#   #
#   # RSpec uses it's own mocking framework by default. If you prefer to
#   # use mocha, flexmock or RR, uncomment the appropriate line:
#   #
#   # config.mock_with :mocha
#   # config.mock_with :flexmock
#   # config.mock_with :rr
# end
