class ClientLogin::ContactsController < ClientLogin::BaseController
  include ControllerMixins::Contacts

  before_filter :load_client
  before_filter :load_contact, :only => [:show, :edit, :update, :destroy]

  access_control do
    allow :client, :to => [:new, :create, :edit, :update, :show, :index], :if => :client_is_current_client?
  end

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
    create!(:client_login_client_contact_path)
  end

  def update
    update!(:client_login_client_contact_path)
  end

  def edit
  end

  def destroy
    destroy!(:client_login_client_contacts_path)
  end

private
  def client_is_current_client?
    Client.for_user(current_user).include?(@client)
  end

end
