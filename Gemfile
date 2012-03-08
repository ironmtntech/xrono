source 'http://rubygems.org'

gem 'acl9', '~> 0.12.0'
gem 'capistrano', '~> 2.8.0'
gem 'devise', '~> 1.4.9'
gem 'gravtastic', '~> 3.2.6'
gem 'haml', '~> 3.1.3'
gem 'paperclip', '~> 2.3'
gem 'rails', '~> 3.2.0'
gem 'uuid', '~> 2.3.1'
gem 'jquery-rails', '~> 1.0.17'
gem 'rake', '0.9.2'
gem 'state_machine', '~> 1.0.2'
gem 'resque', '~> 1.19.0'
gem 'resque_mailer', '~> 2.0.2'
gem 'resque-scheduler', '~> 1.9.9'
gem 'googlecharts', '~> 1.6.8'
gem 'github_concern', '~> 0.1'
gem 'css3-progress-bar-rails', '~> 0.2.2'
gem 'grit', '~> 2.4.0'
gem 'paper_trail', '~> 2.6.0'
gem 'attr_encrypted', '~> 1.2.0'
gem 'acts-as-taggable-on', '~> 2.2.2'
gem 'acts_as_commentable', '~> 3.0.1'
gem 'dynamic_form', '~> 1.0.0'
gem 'kramdown'

gem 'simple-navigation', '~> 3.5.0'
gem 'sass-rails',   '~> 3.2.0'

#gem 'fnordmetric', '~> 0.6.6'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.0'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass', '0.12.alpha.0'
  gem 'bootstrap-sass'
end

group :development do
  gem 'awesome_print', '~> 0.4.0', :require => 'ap'
end

group :test do
  unless ENV['travis'] || RUBY_VERSION >= '1.9.3'
    gem 'ruby-debug19', '~> 0.11.6', :require => 'ruby-debug', :platform => :mri_19
  end
  gem 'awesome_print', '~> 0.4.0',  :require => 'ap'
  gem 'capybara', '~> 1.1.1'
  gem 'cucumber', '~> 1.1.4'
  gem 'cucumber-rails', '~> 1.2.1', :require => false
  gem 'database_cleaner', '~> 0.7.1'
  gem 'faker', '~> 0.9.5'
  gem 'forgery', '= 0.3.10'
  gem 'launchy', '~> 0.3.7'
  gem 'machinist', '~> 1.0.6'
  gem 'pickle', '= 0.4.8'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 1.0'
  gem 'simplecov', '~> 0.5.0'
  gem 'simplecov-rcov'
  gem 'rcov', '0.9.11'
  gem 'spork', '0.9.0.rc9'
  gem 'yajl-ruby', '~> 0.7.8'
  gem 'ci_reporter'
end

platforms :jruby do
  gem 'activerecord-jdbc-adapter', :require => false
  gem 'jdbc-mysql'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'mysql2', '~> 0.3.0'
end

