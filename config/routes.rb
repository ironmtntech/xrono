AssetTrackerTutorial::Application.routes.draw do
  root :to => "dashboard/base#index"

  devise_for :users, :path => '/', :path_names => { :sign_in => 'login', :sign_out => 'logout' }

  namespace :admin do
    resources :invoices
    resources :payroll
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

  resources :clients do
    resources :comments
    resources :contacts
  end

  resources :projects, :except => [:index, :destroy] do
    resources :comments
  end

  resources :tickets, :except => [:index, :destroy] do
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
    end
  end

  get '/dashboard/collaborative_index', :controller => "dashboard/base", :action => "collaborative_index"
  get '/dashboard/collaborative_client', :controller => "dashboard/base", :action => "collaborative_client"
  get '/dashboard/collaborative_project', :controller => "dashboard/base", :action => "collaborative_project"
  get '/dashboard/json_index', :controller => "dashboard/base", :action => "json_index"
  get '/dashboard', :controller => "dashboard/base", :action => "index"
  get '/dashboard/calendar', :controller => "dashboard/base", :action => "calendar"
  get '/dashboard/client', :controller => "dashboard/base", :action => "client"
  get '/dashboard/project', :controller => "dashboard/base", :action => "project"
  get '/dashboard/recent_work', :controller => "dashboard/base", :action => "recent_work"
  get '/dashboard/update_calendar', :controller => "dashboard/base", :action => "update_calendar"
  post '/file_attachments/mark_as_invalid', :controller => "file_attachments", :action => "mark_as_invalid"

  namespace :api do
    namespace :v1 do
      resources :clients
    end

  end
end
