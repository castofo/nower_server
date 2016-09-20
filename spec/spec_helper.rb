require 'support/factory_girl'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

# Performs a GET request with an 'api' subdomain
def sub_get(path, *args)
  get "http://api.example.com/#{path}", *args
end

# Performs a POST request with an 'api' subdomain
def sub_post(path, *args)
  post "http://api.example.com/#{path}", *args
end

# Performs a PUT request with an 'api' subdomain
def sub_put(path, *args)
  put "http://api.example.com/#{path}", *args
end

# Performs a DELETE request with an 'api' subdomain
def sub_delete(path, *args)
  delete "http://api.example.com/#{path}", *args
end
