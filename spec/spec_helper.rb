# Simplecov Setup
if RUBY_VERSION >= '1.9.2'
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails' do
    add_filter '/vendor/'
  end
end

ENV["RAILS_ENV"] ||= 'test'

require 'xrono'
require 'combustion'
Combustion.initialize!

require File.expand_path(File.dirname(__FILE__) + "/blueprints")

require 'rspec/rails'
require 'devise/test_helpers'

require 'sidekiq/testing'
require 'shoulda-matchers'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
load 'spec/support/xrono/macros.rb'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Devise::TestHelpers, :type => :controller

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before(:all)    { Sham.reset(:before_all)  }
  config.before(:each)   { Sham.reset(:before_each) }

  config.use_transactional_fixtures = true
end
