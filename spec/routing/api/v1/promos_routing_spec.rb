require "rails_helper"

RSpec.describe Api::V1::PromosController, type: :routing do
  describe 'routing' do
    describe 'when api subdomain is present' do
      let(:base_url) { 'http://api.example.com' }

      it 'routes to #index' do
        expect(get: "#{base_url}/v1/promos").to route_to('api/v1/promos#index')
      end

      it 'routes to #show' do
        expect(get: "#{base_url}/v1/promos/1").to route_to('api/v1/promos#show', id: '1')
      end

      it 'routes to #create' do
        expect(post: "#{base_url}/v1/promos").to route_to('api/v1/promos#create')
      end

      it 'routes to #update via PUT' do
        expect(put: "#{base_url}/v1/promos/1").to route_to('api/v1/promos#update', id: '1')
      end

      it 'routes to #update via PATCH' do
        expect(patch: "#{base_url}/v1/promos/1").to route_to('api/v1/promos#update', id: '1')
      end

      it 'routes to #destroy' do
        expect(delete: "#{base_url}/v1/promos/1").to route_to('api/v1/promos#destroy', id: '1')
      end
    end

    describe 'when api subdomain is not present' do
      let(:base_url) { 'http://example.com' }

      it 'does not route to #index' do
        expect(get: "#{base_url}/v1/promos").not_to route_to('api/v1/promos#index')
      end

      it 'does not route to #show' do
        expect(get: "#{base_url}/v1/promos/1").not_to route_to('api/v1/promos#show', id: '1')
      end

      it 'does not route to #create' do
        expect(post: "#{base_url}/v1/promos").not_to route_to('api/v1/promos#create')
      end

      it 'does not route to #update via PUT' do
        expect(put: "#{base_url}/v1/promos/1").not_to route_to('api/v1/promos#update', id: '1')
      end

      it 'does not route to #update via PATCH' do
        expect(patch: "#{base_url}/v1/promos/1").not_to route_to('api/v1/promos#update', id: '1')
      end

      it 'does not route to #destroy' do
        expect(delete: "#{base_url}/v1/promos/1").not_to route_to('api/v1/promos#destroy', id: '1')
      end
    end
  end
end
