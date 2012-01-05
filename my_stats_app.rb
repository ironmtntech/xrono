require "fnordmetric"

FnordMetric.namespace :myapp do

# numeric (delta) gauge, 1-hour tick
gauge :git_push_per_hour,
  :tick => 1.hour.to_i,
  :title => "Git push per hour"

gauge :dashboard_views_per_minute,
  :tick => 1.minute.to_i,
  :title => "Dashboard Views per minute"

gauge :dashboard_views_per_second,
  :tick => 1.second.to_i,
  :title => "Dashboard Views per second"

# on every event like { _type: 'unicorn_seen' }
event(:dashboard_view) do
  # increment the unicorns_seen_per_hour gauge by 1
  incr :dashboard_views_per_minute
  incr :dashboard_views_per_second
end

event(:git_push) do
  incr :git_push_per_hour
end

# draw a timeline showing the gauges value, auto-refresh every 2s
widget 'Overview', {
  :title => "Dashboard Views per minute",
  :type => :timeline,
  :gauges => :dashboard_views_per_minute,
  :include_current => true,
  :autoupdate => 2
}

widget 'Overview', {
  :title => "Git Pushes per Hour",
  :type => :timeline,
  :gauges => :git_push_per_hour,
  :include_current => true,
  :autoupdate => 5
}

end

FnordMetric.standalone
