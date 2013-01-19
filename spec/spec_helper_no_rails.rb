# Simplecov Setup
if RUBY_VERSION >= '1.9.2'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/vendor/'
  end
end
ENV["RAILS_ENV"] ||= 'test'
