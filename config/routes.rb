Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => "users/registrations" }
  resources :courses, only: [:index, :show, :edit, :update] do
    resources :registrations
  end
  root 'courses#index'
end
