Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :courses, only: [:show, :edit, :update] do
    resources :registrations 
    member do
    	get :start 
    	post :success
    	post :failure
    	get :result
    end
  end
end
