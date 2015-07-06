Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :courses, only: [:show, :edit, :update] do
    resources :registrations
    member do
    	get :start
      get :closed
    end
    resources :jobs, only: [] do
      member do
        post :success
        post :failure
      end
    end
  end
end
