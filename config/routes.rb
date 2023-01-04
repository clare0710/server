Rails.application.routes.draw do
  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do
  
    get '/sign_in', to: 'sign_in#create'
    get '/users', to: 'users#create'
    end
  end
end
