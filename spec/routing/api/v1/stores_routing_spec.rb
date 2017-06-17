require "rails_helper"

RSpec.describe Api::V1::StoresController, type: :routing do
  describe 'routing' do
    describe 'when api subdomain is present' do
      let(:base_url) { 'http://api.example.com' }

      it 'routes to #index' do
        expect(get: "#{base_url}/v1/stores").to route_to('api/v1/stores#index')
      end

      it 'routes to #show' do
        expect(get: "#{base_url}/v1/stores/1").to route_to('api/v1/stores#show', id: '1')
      end

      it 'routes to #create' do
        expect(post: "#{base_url}/v1/stores").to route_to('api/v1/stores#create')
      end

      it 'routes to #update via PUT' do
        expect(put: "#{base_url}/v1/stores/1").to route_to('api/v1/stores#update', id: '1')
      end

      it 'routes to #update via PATCH' do
        expect(patch: "#{base_url}/v1/stores/1").to route_to('api/v1/stores#update', id: '1')
      end

      it 'routes to #destroy' do
        expect(delete: "#{base_url}/v1/stores/1").to route_to('api/v1/stores#destroy', id: '1')
      end
    end

    describe 'when api subdomain is not present' do
      let(:base_url) { 'http://example.com' }

      it 'does not route to #index' do
        expect(get: "#{base_url}/v1/stores").not_to route_to('api/v1/stores#index')
      end

      it 'does not route to #show' do
        expect(get: "#{base_url}/v1/stores/1").not_to route_to('api/v1/stores#show', id: '1')
      end

      it 'does not route to #create' do
        expect(post: "#{base_url}/v1/stores").not_to route_to('api/v1/stores#create')
      end

      it 'does not route to #update via PUT' do
        expect(put: "#{base_url}/v1/stores/1").not_to route_to('api/v1/stores#update', id: '1')
      end

      it 'does not route to #update via PATCH' do
        expect(patch: "#{base_url}/v1/stores/1").not_to route_to('api/v1/stores#update', id: '1')
      end

      it 'does not route to #destroy' do
        expect(delete: "#{base_url}/v1/stores/1").not_to route_to('api/v1/stores#destroy', id: '1')
      end
    end
  end
end
