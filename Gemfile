source 'http://rubygems.org'

gemspec
# Gems used only for assets and not required
# in production environments by default.
gem 'rails4_upgrade'
group :development do
  # Use combustion for testing the engine
  gem 'combustion', '0.3.3'
end

group :development, :test do
  gem 'selenium-webdriver'
  gem 'pry'
end

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'jruby-openssl'
  gem 'trinidad'
end

platforms :ruby do
  gem 'pg'
  gem 'mysql2', '~> 0.3.0'
end

