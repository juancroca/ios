Rails.application.routes.draw do
  root to: 'static#root'

  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :courses, only: [:show, :edit, :update] do
    resources :registrations
    member do
    	get :start
      get :closed
    end
    resources :jobs, only: [:edit, :create] do
      member do
        post :success
        post :failure
      end
    end
  end
end
