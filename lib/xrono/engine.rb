require 'rails'
require 'devise'
require 'acl9'
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

module ::Xrono
  class Engine < Rails::Engine
    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    config.to_prepare do
      # add xrono helpers to main application
      ::ApplicationController.send :helper, Xrono::Engine.helpers
    end
  end
end
