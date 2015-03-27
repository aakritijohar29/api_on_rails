require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  #Api definition
  namespace :api, defaults: { format: :json },
                            constraints: { subdomain: 'api' }, path: '/' do

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      #List our resources here
      resources :users, :only => [:index, :show, :create, :update, :destroy] do
        resources :products, :only => [:create]
      end
      resources :sessions, :only => [:create, :destroy]
      resources :products, :only => [:index, :show]
    end

  end
end
