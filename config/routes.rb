Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Public menu view (no authentication required)
  get "/m/:id", to: "menus#public", as: :public_menu

  # Menu management routes
  resources :menus do
    member do
      get :qr_code
    end
    resources :sections, except: [ :index, :show ]
  end

  resources :sections, only: [] do
    resources :menu_items, except: [ :index, :show ]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
