Rails.application.routes.draw do
  namespace :api, path: '', constraints: lambda { |rq| rq.subdomain.split('.').first == 'api' } do
    namespace :v1 do
      resources :promos

      get 'auths/index' # TODO: Delete, development purposes.
      post 'auths/login'
      post 'auths/register'
    end
  end
end
