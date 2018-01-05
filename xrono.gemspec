Gem::Specification.new do |s|
  s.name = 'xrono'
  s.authors = ['Josh Adams', 'Adam Dill', 'Adam Gamble', 'Robby Clements']
  s.summary = 'An asset and time tracking application for consultants and consulting companies.'
  s.description = 'Xrono is an asset and time tracking application for consultants and consulting companies.'
  s.files = `git ls-files`.split("\n")
  s.email = "josh@isotope11.com"
  s.homepage = "http://www.xrono.org"
  s.version = %q(1.0.14)

  s.add_dependency 'rails', '4.0.6'
  s.add_dependency 'railties', '4.0.6'
  s.add_dependency 'acl9'#, '~> 0.12.0'
  s.add_dependency 'devise'#, '~> 2.2.8'
  s.add_dependency 'devise-encryptable', '~> 0.1.1'
  s.add_dependency 'gravtastic', '~> 3.2.6'
  s.add_dependency 'haml'#, '~> 3.1.3'
  s.add_dependency 'paperclip', '~> 2.3'
  s.add_dependency 'uuid', '~> 2.3.1'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'rake', '~> 10.0'
  s.add_dependency 'state_machine', '~> 1.0.2'
  s.add_dependency 'googlecharts', '~> 1.6.8'
  s.add_dependency 'css3-progress-bar-rails', '~> 0.2.2'
  s.add_dependency 'grit', '~> 2.4.0'
  s.add_dependency 'paper_trail', '3.0.0'
  s.add_dependency 'attr_encrypted', '~> 1.2.0'
  s.add_dependency 'acts-as-taggable-on'
  s.add_dependency 'acts_as_commentable'
  s.add_dependency 'dynamic_form', '~> 1.0.0'
  s.add_dependency 'kramdown'
  s.add_dependency 'doorkeeper'
  s.add_dependency 'oauth2'
  s.add_dependency 'sidekiq', '3.1.3'
  s.add_dependency 'simple-navigation-bootstrap'
  s.add_dependency 'coffee-rails', '~> 4.0.0'
  s.add_dependency 'uglifier', '>= 1.3.0'
  s.add_dependency 'compass'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'sass-rails', '4.0.3'
  s.add_dependency 'chosen-rails'
  s.add_dependency 'protected_attributes'

  s.add_development_dependency 'capistrano', '~> 2.8.0'
  s.add_development_dependency 'capybara', '~> 2.2.0'
  s.add_development_dependency 'cucumber', '~> 1.1.4'
  s.add_development_dependency 'database_cleaner', '~> 0.7.1'
  s.add_development_dependency 'faker', '~> 0.9.5'
  s.add_development_dependency 'forgery', '= 0.3.10'
  s.add_development_dependency 'launchy', '~> 0.3.7'
  s.add_development_dependency 'machinist', '~> 1.0.6'
  s.add_development_dependency 'pickle', '= 0.4.8'
  s.add_development_dependency 'shoulda-matchers'#, '~> 1.0'
  s.add_development_dependency 'simplecov'#, '~> 0.5.0'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'spork', '0.9.0.rc9'
  s.add_development_dependency 'ci_reporter'
  s.add_development_dependency 'rspec-rails'#, '>=2.13.2'
end
