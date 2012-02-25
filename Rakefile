# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'resque/tasks'
require 'resque_scheduler/tasks'

require 'rubygems'
require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
require 'ci/reporter/rake/cucumber'

AssetTrackerTutorial::Application.load_tasks
