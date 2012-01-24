source 'http://rubygems.org'

gem 'acl9', '~> 0.12.0'
gem 'capistrano', '~> 2.8.0'
gem 'devise', '~> 1.4.9'
gem 'gravtastic'
gem 'haml', '~> 3.1.3'
gem 'mysql2', '~> 0.3.0'
gem 'paperclip', '~> 2.3'
gem 'rails', '~> 3.1.0'
gem 'thin', '~> 1.2.7'
gem 'uuid', '~> 2.3.1'
gem 'jquery-rails'
gem 'rake', '0.9.2'
gem 'sqlite3'
gem 'state_machine', '~> 1.0.2'
gem 'acts_as_audited', '~> 2.0.0'
gem 'resque', '~> 1.19.0'
gem 'resque_mailer', '~> 2.0.2'
gem 'resque-scheduler', '~> 1.9.9'
gem 'googlecharts', '~> 1.6.8'
gem 'github_concern', '~> 0.0'
gem 'css3-progress-bar-rails'

gem 'simple-navigation'
gem 'sass-rails',   '~> 3.1.4'

gem 'fnordmetric', '~> 0.6.6'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass', '0.12.alpha.0'
  gem 'twitter-bootstrap-rails'
end 

group :production do
  gem 'therubyracer'
end

group :development do
  gem 'awesome_print', :require => 'ap'
end

group :test do
  unless ENV['travis']
    gem 'ruby-debug19', :require => 'ruby-debug'
  end
  gem 'awesome_print', :require => 'ap'
  gem 'capybara', '~> 1.1.1'
  gem 'cucumber', '~> 1.0.6'
  gem 'cucumber-rails', '~> 1.0.5'
  gem 'database_cleaner', '~> 0.6.7'
  gem 'escape_utils', '~> 0.1.9'
  gem 'faker', '~> 0.9.5'
  gem 'forgery', '= 0.3.10'
  gem 'launchy', '~> 0.3.7'
  gem 'machinist', '~> 1.0.6'
  gem 'pickle', '= 0.4.8'
  gem 'rspec', '~> 2.6.0'
  gem 'rspec-rails', '= 2.6.1'
  gem 'shoulda', '~> 2.11.3'
  gem 'simplecov', '~> 0.5.0'
  gem 'spork', '0.9.0.rc9'
  gem 'yajl-ruby', '~> 0.7.8'
end
