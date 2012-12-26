require 'rails'
require 'devise'
require 'acl9'
require 'acl9/model_extensions'
require 'acl9/controller_extensions'
require 'acl9/helpers'
require 'gravtastic'
require 'haml'
require 'paperclip'
require 'uuid'
require 'jquery-rails'
require 'rake'
require 'state_machine'
require 'googlecharts'
require 'github_concern'
require 'css3-progress-bar-rails'
require 'grit'
require 'paper_trail'
require 'attr_encrypted'
require 'acts-as-taggable-on'
require 'acts_as_commentable'
require 'dynamic_form'
require 'kramdown'
require 'doorkeeper'
require 'oauth2'
require 'sidekiq'
require 'simple-navigation-bootstrap'
require 'sass-rails'

class Xrono < Rails::Engine
  class << self
    attr_accessor :root
    def root
      @root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end

  config.to_prepare do
    # add xrono helpers to main application
    require File.join(Xrono.root.to_s, '..', 'app', 'controllers', 'xrono', 'application_controller')
    ::ApplicationController.send :helper, Xrono.helpers
  end
  ActiveRecord::Base.send(:include, Acl9::ModelExtensions)
  ActionController::Base.send(:include, Acl9::ControllerExtensions)
end
