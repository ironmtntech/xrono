class ContactsController < ApplicationController
  include ControllerMixins::Contacts

  before_filter :load_client
  before_filter :load_contact, :only => [:show, :edit, :update, :destroy]
  before_filter :require_admin, :only => [:destroy]

  access_control do
    allow :admin
    allow :developer, :if => :current_user_has_client
    allow :client, :to => [:new, :create, :edit, :update, :destroy, :show, :index], :if => :current_user_has_client
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
    create!(:client_contact_path)
  end

  def update
    update!(:client_contact_path)
  end

  def edit
  end

  def destroy
    destroy!(:client_contacts_path)
  end

private
  def current_user_has_client
    Client.for_user(current_user).include?(@client)
  end

end
