ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "database_cleaner/active_record"

module ActiveSupport
  class TestCase
    include Devise::Test::IntegrationHelpers
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    DatabaseCleaner.strategy = :transaction

    setup do
      DatabaseCleaner.start
    end
    teardown do
      DatabaseCleaner.clean
    end
  end
end
