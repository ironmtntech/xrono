module ControllerMixins
  module Authorization
    extend ActiveSupport::Concern

    module ClassMethods
      def authorize_owners_with_client_show(object)
        access_control do
          allow :admin
          allow :developer, :of => object
          allow :client, :of => object, :to => :show
        end
      end
    end
  end
end
