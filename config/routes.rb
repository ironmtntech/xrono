Rails.application.routes.draw do
  mount Doorkeeper::Engine => '/oauth'

  root :to => "dashboard/base#index"

  devise_for :users, :path => '/', :path_names => { :sign_in => 'login', :sign_out => 'logout' }

  post "/data_vaults/:id", :to => "data_vaults#update"
  resources :data_vaults, :only => [:show]

  namespace :admin do
    resources :invoices, only: [:show, :update, :index]
    resources :payroll
    get :locked_users,     :controller => :users, :action => :locked_users
    get :unlocked_clients, :controller => :users, :action => :unlocked_clients
    get :locked_clients,   :controller => :users, :action => :locked_clients
    resources :users, except: [:destroy] do
      member do
        get :projects
        post :projects
      end
    end
    resources :projects
    resources :unentered_time_report
    resources :weekly_time_report
    resource :site_settings, only: [:edit, :update, :destroy]
  end
  get '/admin', :controller => "admin/base", :action => "index"
  get '/admin/reports', :controller => "admin/base", :action => "reports"

  namespace :client_login do
    root :to => "clients#index"
    resources :reports, :only => [:index] do
      collection do
        match :work_units
      end
    end
    resources :clients, only: [:show, :index] do
      resources :contacts
    end
    resources :projects, only: [:show]
    resources :tickets
    resources :work_units
  end

  match '/client/:id' => 'clients#show'
  get :inactive_clients, :controller => :clients, :action => :inactive_clients
  get :suspended_clients, :controller => :clients, :action => :suspended_clients
  resources :clients, except: [:destroy] do
    resources :comments, except: [:index]
    resources :contacts
    get :show_complete, :controller => :clients, :action => :show_complete
  end

  resources :projects, :except => [:index, :destroy] do
    resources :comments, except: [:index]
    get "show_complete", :controller => :projects, :action => "show_complete"
  end

  resources :tickets, :except => [:index, :destroy] do
    post 'advance_state', :controller => :tickets, :action => :advance_state
    post 'reverse_state', :controller => :tickets, :action => :reverse_state
    get 'ticket_detail', :controller => :tickets, :action => :ticket_detail
    put 'toggle_complete', :controller => :tickets, :action => :toggle_complete
    resources :comments, except: [:index]
    resources :work_units, only: [:show, :new, :edit, :update]
  end

  resources :work_units, :only => [:show, :new, :edit, :update, :index] do
    collection do
      post :create_in_ticket
      post :create_in_dashboard
    end

    resources :comments, except: [:index]
  end

  resources :users, only: [:show, :edit, :update, :index] do
    member do
      put :change_password
      get :historical_time
    end
  end

  resources :comments

  resources :file_attachments, only: [:show, :new, :create]

  namespace :dashboard do
    get :json_index, :controller => "base", :action => :json_index
    resources :base do
    end
  end

  get '/dashboard', :controller => "dashboard/base", :action => :index
  get '/dashboard/calendar', :controller => "dashboard/base", :action => "calendar"
  get '/dashboard/client', :controller => "dashboard/base", :action => "client"
  get '/dashboard/project', :controller => "dashboard/base", :action => "project"
  get '/dashboard/recent_work', :controller => "dashboard/base", :action => "recent_work"
  get '/dashboard/update_calendar', :controller => "dashboard/base", :action => "update_calendar"
  post '/file_attachments/mark_as_invalid', :controller => "file_attachments", :action => "mark_as_invalid"

  namespace :api do
    namespace :v1 do
      resources :tokens, :only => [:create]
      resources :clients, :only => [:index]
      resources :projects, :only => [:index, :create]
      resources :tickets, :only => [:index, :show, :create]
      resources :work_units, :only => [:index, :create]
      get '/me' => "credentials#me"
    end
  end
end
