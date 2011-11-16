ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require File.expand_path(File.dirname(__FILE__) + "/../../spec/blueprints")

if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end
