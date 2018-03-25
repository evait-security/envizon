require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:john)
    users(:john).run_callbacks(:create)
  end
end
