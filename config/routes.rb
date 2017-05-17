Rails.application.routes.draw do
  namespace :api, path: '', constraints: lambda { |rq| rq.subdomain.split('.').first == 'api' } do
    namespace :v1 do
      resources :promos
      resources :branches

      get 'auths/index' # TODO: Delete, development purposes.
      post 'auths/login'
      post 'auths/register'

      get 'admins/index' # TODO: Delete, development purposes.
      post 'admins/login'
      post 'admins/register'
    end
  end
end
