module ControllerMixins
  module Generic
    protected
    def generic_save_and_redirect(object_type, action_type)
      instance = instance_variable_get("@#{object_type}")
      if instance.save
        flash[:notice] = t("#{object_type}_#{action_type}d_successfully".to_sym)
        redirect_to send("#{object_type}_path", instance)
      else
        flash.now[:error] = t("#{object_type}_#{action_type}d_unsuccessfully".to_sym)
        render :action => 'new'
      end
    end
  end
end
