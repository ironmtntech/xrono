class ContactsController < ApplicationController
  before_filter :load_client
  before_filter :load_contact, :only => [:show, :edit, :update, :destroy]
  before_filter :require_admin, :only => [:destroy]

  protected
  def load_client
    @client = Client.find(params[:client_id])
  end

  def load_contact
    @contact = Contact.find(params[:id])
  end


  public
  def index
    @contacts = @client.contacts.all
  end

  def show
  end

  def new
    @contact = Contact.new(params[:contact])
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.client = @client
    if @contact.save
      flash[:notice] = "Contact created successfully."
      redirect_to client_contact_path(@contact.client, @contact)
    else
      flash.now[:error] = "There was a problem saving the new contact."
      render :action => 'new'
    end
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Contact updated successfully."
      redirect_to client_contact_path
    else
      flash.now[:error] = "There was a problem saving the contact."
      render :action => 'edit'
    end
  end

  def edit
  end

  def destroy
    @contact = Contact.find(params[:id])
    if @contact.destroy
      flash[:notice] = "Contact was successfully deleted"
      redirect_to client_contacts_path
    else
      flash.now[:error] = "There was a problem deleting the contact."
      render :action => 'show'
    end
  end

end
