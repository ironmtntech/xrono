# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AssetTrackerTutorial::Application.initialize!

#This is a hack so that github integration works.
#Take that lazy loading!
[Project,Ticket]
