class Doorkeeper::TokensController < Doorkeeper::ApplicationController
  skip_before_filter :initialize_site_settings
  skip_before_filter :redirect_clients
  skip_before_filter :authenticate_user!

  def create
    response.headers.merge!({
      'Pragma'        => 'no-cache',
      'Cache-Control' => 'no-store',
    })
    if token.authorize
      render :json => token.authorization
    else
      render :json => token.error_response, :status => token.error_response.status
    end
  end

  private

  def client
    @client ||= Doorkeeper::OAuth::Client.authenticate(credentials)
  end

  def credentials
    methods = Doorkeeper.configuration.client_credentials_methods
    @credentials ||= Doorkeeper::OAuth::Client::Credentials.from_request(request, *methods)
  end

  def token
    case params[:grant_type]
    when 'password'
      owner = resource_owner_from_credentials
      @token ||= Doorkeeper::OAuth::PasswordAccessTokenRequest.new(client, owner, params)
    when 'client_credentials'
      @token ||= Doorkeeper::OAuth::ClientCredentialsRequest.new(Doorkeeper.configuration, client, params)
    else
      @token ||= Doorkeeper::OAuth::AccessTokenRequest.new(client, params)
    end
  end

    def authenticate_resource_owner!
      current_resource_owner
    end

    def current_resource_owner
      instance_exec(main_app, &Doorkeeper.configuration.authenticate_resource_owner)
    end

    def resource_owner_from_credentials
      instance_exec(main_app, &Doorkeeper.configuration.resource_owner_from_credentials)
    end

    def authenticate_admin!
      if block = Doorkeeper.configuration.authenticate_admin
        instance_exec(main_app, &block)
      end
    end

    def method_missing(method, *args, &block)
      if method =~ /_(url|path)$/
        raise "Your path has not been found. Didn't you mean to call routes.#{method} in doorkeeper configuration blocks?"
      else
        super
      end
    end
end
