Rails.application.routes.draw do
  namespace :api, path: '', constraints: lambda { |rq| rq.subdomain.split('.').first == 'api' } do
    namespace :v1 do
      resources :promos
    end
  end
end
