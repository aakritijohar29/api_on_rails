Rails.application.routes.draw do
  #Api definition
  namespace :api, defaults: { format: :json },
                            constraints: { subdomain: 'api' }, path: '/' do
    #List our resources here
  end
end
