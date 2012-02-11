module ControllerMixins
  module Contacts
    def create!(path)
      @contact = Contact.new(params[:contact])
      @contact.client = @client
      if @contact.save
        flash[:notice] = "Contact created successfully."
        redirect_to send(path, @contact.client, @contact)
      else
        flash.now[:error] = "There was a problem saving the new contact."
        render :action => 'new'
      end
    end

    def update!(path)
      @contact = Contact.find(params[:id])
      if @contact.update_attributes(params[:contact])
        flash[:notice] = "Contact updated successfully."
        redirect_to send(path)
      else
        flash.now[:error] = "There was a problem saving the contact."
        render :action => 'edit'
      end
    end

    def destroy!(path)
      @contact = Contact.find(params[:id])
      if @contact.destroy
        flash[:notice] = "Contact was successfully deleted"
        redirect_to send(path)
      else
        flash.now[:error] = "There was a problem deleting the contact."
        render :action => 'show'
      end
    end
  end
end
