# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AssetTrackerTutorial::Application.initialize!

# Set Haml Options:
Haml::Template.options[:format] = :xhtml