Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :courses, only: [:index, :show, :edit, :update] do
    resources :registrations
    member do
    	get :start 
    	post :success
    	post :failure
    end
  end
  root 'courses#index'
end
