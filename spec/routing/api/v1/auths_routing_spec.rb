require 'rails_helper'

RSpec.describe Api::V1::AuthsController, type: :routing do
  describe 'routing' do
    describe 'when api subdomain is present' do
      let(:base_url) { 'http://api.example.com' }

      it 'routes to #login' do
        expect(post: "#{base_url}/v1/auths/login").to route_to('api/v1/auths#login')
      end

      it 'routes to #register' do
        expect(post: "#{base_url}/v1/auths/register").to route_to('api/v1/auths#register')
      end
    end

    describe 'when api subdomain is not present' do
      let(:base_url) { 'http://example.com' }

      it 'does not route to #login' do
        expect(post: "#{base_url}/v1/auths/login").not_to route_to('api/v1/auths#login')
      end

      it 'does not route to #register' do
        expect(post: "#{base_url}/v1/auths/register").not_to route_to('api/v1/auths#register')
      end
    end
  end
end
