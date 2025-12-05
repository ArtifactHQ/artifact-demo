Rails.application.routes.draw do
  # Main application routes - nested resources
  resources :projects do
    resources :documents do
      member do
        post :commit_version
        get :preview
      end
      resources :versions, only: [:index, :show] do
        member do
          post :deploy
          post :rollback
        end
      end
    end
  end

  # Dashboard and home
  get "dashboard", to: "projects#index", as: :dashboard

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Development-only routes
  if Rails.env.development?
    get "docs" => "pages#docs", as: :docs
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/") - Keep original product mockup UI
  root "pages#home"
end
