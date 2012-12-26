#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.


require 'rake'

require 'rubygems'
require 'bundler/setup'
Bundler.require :default, :development
Combustion::Application.load_tasks
begin
  require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
rescue LoadError
end
