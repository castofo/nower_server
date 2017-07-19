Rails.application.routes.draw do
  namespace :api, path: '', constraints: lambda { |rq| rq.subdomain.split('.').first == 'api' } do
    namespace :v1 do
      resources :promos
      resources :branches
      resources :stores
      resources :contact_informations

      get 'auths/index'
      post 'auths/login'
      post 'auths/register'

      get 'admins/index'
      post 'admins/login'
      post 'admins/register'
    end
  end
end
