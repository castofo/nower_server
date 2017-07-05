require 'rails_helper'

RSpec.describe 'Stores', type: :request do
  describe 'GET /v1/stores' do
    context 'when there is no stores' do
      it 'returns an empty array' do
        sub_get api_v1_stores_path
        expect(response).to have_http_status(200)
        stores = JSON.parse(response.body)
        expect(stores).to be_a_kind_of Array
        expect(stores).to be_empty
      end
    end

    context 'when there is a store' do
      let!(:existing_store) { create :store }
      it 'returns an array with the store' do
        sub_get api_v1_stores_path
        expect(response).to have_http_status(200)
        stores = JSON.parse(response.body)
        expect(stores.length).to eq 1
        expect(stores.first['id']).to eq existing_store.id
        expect(stores.first['name']).to eq existing_store.name
        expect(stores.first['description']).to eq existing_store.description
      end
    end

    context "when 'expand' query param contains 'branches'" do

      # Create some stores with branches
      before do
        rand(5..10).times do
          store = create :store
          rand(5..10).times { create(:branch, store_id: store.id) }
        end
      end

      it 'returns stores with embedded branches entities' do
        sub_get api_v1_stores_path, { params: { expand: :branches } }
        expect(response).to have_http_status(200)
        stores = JSON.parse(response.body)
        stores.each do |store|
          expect(store['branches']).not_to be_nil
          expect(store['branches']).to be_a_kind_of(Array)
        end
      end
    end
  end

  describe 'GET /v1/stores/:id' do
    let(:existing_store) { create :store }
    context 'when id is valid' do
      it 'returns the store' do
        sub_get api_v1_store_path(existing_store.id)
        expect(response).to have_http_status(200)
        found_store = JSON.parse(response.body)
        expect(found_store['id']).to eq existing_store.id
        expect(found_store['name']).to eq existing_store.name
        expect(found_store['description']).to eq existing_store.description
      end
    end

    context "when 'expand' query param contains 'store'" do
      let(:branches_count) { rand(5..10) }
      before do
        branches_count.times { create(:branch, store_id: existing_store.id) }
      end

      it 'returns the store with embedded branches entities' do
        sub_get api_v1_store_path(existing_store.id), { params: { expand: :branches } }
        expect(response).to have_http_status(200)
        found_store = JSON.parse(response.body)
        expect(found_store['branches']).not_to be_nil
        expect(found_store['branches']).to be_a_kind_of(Array)
        expect(found_store['branches'].length).to eq branches_count
      end
    end

    context 'when id is invalid' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_get api_v1_store_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /v1/stores' do
    let(:body) { attributes_for :store }
    context 'when all attributes are valid' do
      it 'creates the store' do
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['name']).to eq body[:name]
        expect(created_store['description']).to eq body[:description]
        expect(created_store['nit']).to eq body[:nit]
      end

      it 'sets pending_documentation as default status' do
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['status']).to eq 'pending_documentation'
      end
    end

    context 'when name is not present' do
      it 'returns a 422' do
        body[:name] = nil
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when name is empty' do
      it 'returns a 422' do
        body[:name] = ''
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when name has more than 50 characters' do
      it 'returns a 422' do
        body[:name] = Faker::Lorem.characters(51)
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when description is not present' do
      it 'returns a 422' do
        body[:description] = nil
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when description is empty' do
      it 'returns a 422' do
        body[:description] = ''
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when nit is not present' do
      it 'returns a 422' do
        body[:nit] = nil
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when nit is empty' do
      it 'returns a 422' do
        body[:nit] = ''
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when website is nil' do
      it 'creates the store' do
        body[:website] = nil
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['website']).to be_nil
      end
    end

    context 'when website is empty' do
      it 'creates the store' do
        body[:website] = ''
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['website']).to eq ''
      end
    end

    context 'when address is nil' do
      it 'creates the store' do
        body[:address] = nil
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['address']).to be_nil
      end
    end

    context 'when address is empty' do
      it 'creates the store' do
        body[:address] = ''
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['address']).to eq ''
      end
    end

    context 'when status is nil' do
      it 'creates the store with pending_documentation status' do
        body[:status] = nil
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['status']).to eq 'pending_documentation'
      end
    end

    context 'when status is empty' do
      it 'creates the store with pending_documentation status' do
        body[:status] = ''
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['status']).to eq 'pending_documentation'
      end
    end

    context 'when status is active' do
      it 'creates the store with pending_documentation status' do
        body[:status] = :active
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['status']).to eq 'pending_documentation'
      end
    end

    context 'when status random string' do
      it 'creates the store with pending_documentation status' do
        body[:status] = Faker::Lorem.word
        sub_post api_v1_stores_path, { params: { store: body } }
        expect(response).to have_http_status(201)
        created_store = JSON.parse(response.body)
        expect(created_store['status']).to eq 'pending_documentation'
      end
    end
  end

  describe 'PUT /v1/stores' do
    let(:existing_store) { create :store }
    let(:body) do
      { name: Faker::Lorem.sentence[0..49], description: Faker::Lorem.paragraph }
    end
    context 'when updating an existing store' do
      context 'when new name is valid' do
        it 'updates the store' do
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['name']).to eq body[:name]
          expect(updated_store['description']).to eq body[:description]
        end
      end

      context 'when name is nil' do
        it 'returns a 422' do
          body[:name] = nil
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when name is empty' do
        it 'returns a 422' do
          body[:name] = ''
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when name has more than 50 characters' do
        it 'returns a 422' do
          body[:name] = Faker::Lorem.characters(51)
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when description is nil' do
        it 'returns a 422' do
          body[:description] = nil
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when description is empty' do
        it 'returns a 422' do
          body[:description] = ''
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when nit is not present' do
        it 'returns a 422' do
          body[:nit] = nil
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when nit is empty' do
        it 'returns a 422' do
          body[:nit] = ''
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when website is nil' do
        it 'updates the store' do
          body[:website] = nil
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['website']).to be_nil
        end
      end

      context 'when website is empty' do
        it 'updates the store' do
          body[:website] = ''
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['website']).to eq ''
        end
      end

      context 'when address is nil' do
        it 'updates the store' do
          body[:address] = nil
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['address']).to be_nil
        end
      end

      context 'when address is empty' do
        it 'updates the store' do
          body[:address] = ''
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['address']).to eq ''
        end
      end

      context 'when status is nil' do
        it 'updates the store keeping the same status' do
          body[:status] = nil
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['status']).to eq existing_store.status
        end
      end

      context 'when status is empty' do
        it 'updates the store keeping the same status' do
          body[:status] = ''
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['status']).to eq existing_store.status
        end
      end

      context 'when status is active' do
        it 'updates the store keeping the same status' do
          body[:status] = :active
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['status']).to eq existing_store.status
        end
      end

      context 'when status random string' do
        it 'updates the store keeping the same status' do
          body[:status] = Faker::Lorem.word
          sub_put api_v1_store_path(existing_store.id), { params: { store: body } }
          expect(response).to have_http_status(200)
          updated_store = JSON.parse(response.body)
          expect(updated_store['status']).to eq existing_store.status
        end
      end
    end

    context 'when updating a non-existing store' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_put api_v1_store_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /v1/stores' do
    context 'when deleting an existing store' do
      let(:existing_store) { create :store }
      it 'returns a 200' do
        sub_delete api_v1_store_path(existing_store.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when deleting a non-existing store' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_delete api_v1_store_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
