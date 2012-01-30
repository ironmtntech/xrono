AssetTrackerTutorial::Application.routes.draw do
  root :to => "dashboard/base#index"

  devise_for :users, :path => '/', :path_names => { :sign_in => 'login', :sign_out => 'logout' }

  namespace :admin do
    resources :invoices
    resources :payroll
    get :locked_users, :controller => :users, :action => :locked_users
    resources :users do
      member do
        get :projects
        post :projects
      end
    end
    resources :projects
    resources :unentered_time_report
    resources :weekly_time_report
    resource :site_settings
  end
  get '/admin', :controller => "admin/base", :action => "index"
  get '/admin/reports', :controller => "admin/base", :action => "reports"

  match '/client_login' => "client_login/base#index"
  namespace :client_login do
    resources :clients do
      resources :contacts
    end
    resources :projects, :tickets, :work_units
  end

  match '/client/:id' => 'clients#show'
  get :inactive_clients, :controller => :clients, :action => :inactive_clients
  get :suspended_clients, :controller => :clients, :action => :suspended_clients
  resources :clients do
    resources :comments
    resources :contacts
    get :show_complete, :controller => :clients, :action => :show_complete
  end

  resources :projects, :except => [:index, :destroy] do
    resources :comments
    get "show_complete", :controller => :projects, :action => "show_complete"
  end

  resources :tickets, :except => [:index, :destroy] do
    post 'advance_state', :controller => :tickets, :action => :advance_state
    post 'reverse_state', :controller => :tickets, :action => :reverse_state
    get 'ticket_detail', :controller => :tickets, :action => :ticket_detail
    put 'toggle_complete', :controller => :tickets, :action => :toggle_complete
    resources :comments
    resources :work_units
  end

  resources :work_units, :except => [:destroy, :create] do
    collection do
      post :create_in_ticket
      post :create_in_dashboard
    end

    resources :comments
  end

  resources :users do
    member do
      put :change_password
      get :historical_time
    end
  end

  resources :comments

  resources :file_attachments

  namespace :dashboard do
    resources :base do
      collection do
        post :give_me_the_tickets
      end
    end
  end

  get '/dashboard/collaborative_index', :controller => "dashboard/base", :action => "collaborative_index"
  get '/dashboard/collaborative_client', :controller => "dashboard/base", :action => "collaborative_client"
  get '/dashboard/collaborative_project', :controller => "dashboard/base", :action => "collaborative_project"
  get '/dashboard/json_index', :controller => "dashboard/base", :action => "json_index"
  get '/dashboard', :controller => "dashboard/base", :action => "index"
  get '/dashboard/collaborative_index', :controller => "dashboard/base", :action => "collaborative_index"
  get '/dashboard/collaborative_client', :controller => "dashboard/base", :action => "collaborative_client"
  get '/dashboard/collaborative_project', :controller => "dashboard/base", :action => "collaborative_project"
  get '/dashboard/json_index', :controller => "dashboard/base", :action => "json_index"
  get '/dashboard/calendar', :controller => "dashboard/base", :action => "calendar"
  get '/dashboard/client', :controller => "dashboard/base", :action => "client"
  get '/dashboard/project', :controller => "dashboard/base", :action => "project"
  get '/dashboard/recent_work', :controller => "dashboard/base", :action => "recent_work"
  get '/dashboard/update_calendar', :controller => "dashboard/base", :action => "update_calendar"
  post '/file_attachments/mark_as_invalid', :controller => "file_attachments", :action => "mark_as_invalid"

  namespace :api do
    namespace :v1 do
      resources :tokens, :only => [:create, :destroy]
      resources :clients, :only => [:index, :create]
      resources :projects, :only => [:index, :create]
      resources :tickets, :only => [:index, :create, :show]
      resources :work_units, :only => [:create]
    end
  end
end
