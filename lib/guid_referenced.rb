module GuidReferenced
  extend ActiveSupport::Concern

  included do
    class_eval do
      validates_uniqueness_of :guid
      validates_presence_of :guid

      before_validation :generate_guid, :on => :create
    end
  end

  module InstanceMethods
    protected
    def generate_guid
      if guid.blank?
        self.guid = UUID.generate
      end
    end
  end
end
