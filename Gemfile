source 'http://rubygems.org'

gemspec
# Gems used only for assets and not required
# in production environments by default.
gem 'rails4_upgrade'
group :development do
  # Use combustion for testing the engine
  gem 'combustion', '0.3.1'
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
  gem 'mysql2'
end

#gem 'actionpack-action_caching', '~>1.0.0'
#gem 'actionpack-page_caching', '~>1.0.0'
#gem 'actionpack-xml_parser', '~>1.0.0'
#gem 'actionview-encoded_mail_to', '~>1.0.4'
#gem 'activerecord-session_store', '~>0.0.1'
#gem 'activeresource', '~>4.0.0.beta1'
#gem 'protected_attributes', '~>1.0.1'
#gem 'rails-observers', '~>0.1.1'
#gem 'rails-perftest', '~>0.0.2'

