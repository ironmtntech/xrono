load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'deploy/assets'
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks
