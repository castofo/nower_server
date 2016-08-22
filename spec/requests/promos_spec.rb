require 'rails_helper'

RSpec.describe 'Promos', type: :request do
  describe 'GET /api/v1/promos' do
    context 'when there is no promos' do
      it 'returns an empty array' do
        get api_v1_promos_path
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos).to be_a_kind_of Array
        expect(promos).to be_empty
      end
    end

    context 'when there is a promo' do
      let!(:existing_promo) { create :promo }
      it 'returns an array with the job' do
        get api_v1_promos_path
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos.length).to eq 1
        expect(promos.first['id']).to eq existing_promo.id
        expect(promos.first['name']).to eq existing_promo.name
        expect(promos.first['description']).to eq existing_promo.description
      end
    end
  end

  describe 'GET /api/v1/promos/:id' do
    let(:existing_promo) { create :promo }
    context 'when id is valid' do
      it 'returns the promo' do
        get api_v1_promo_path(existing_promo.id)
        expect(response).to have_http_status(200)
        found_promo = JSON.parse(response.body)
        expect(found_promo['id']).to eq existing_promo.id
        expect(found_promo['name']).to eq existing_promo.name
        expect(found_promo['description']).to eq existing_promo.description
      end
    end

    context 'when id is invalid' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          get api_v1_promo_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /api/v1/promos' do
    let(:body) { attributes_for :promo }
    context 'when name is not empty' do
      it 'creates the promo' do
        post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
        created_promo = JSON.parse(response.body)
        expect(created_promo['name']).to eq body[:name]
      end
    end

    context 'when name is not present' do
      it 'returns a 422' do
        body[:name] = nil
        post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /api/v1/promos' do
    let(:existing_promo) { create :promo }
    let(:body) do
      { name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph }
    end
    context 'when updating an existing promo' do
      context 'when new name is valid' do
        it 'updates the promo' do
          put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
          updated_promo = JSON.parse(response.body)
          expect(updated_promo['name']).to eq body[:name]
          expect(updated_promo['description']).to eq body[:description]
        end
      end

      context 'when name is not present' do
        it 'returns a 422' do
          body[:name] = nil
          put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when updating a non-existing promo' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          put api_v1_promo_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /api/v1/promos' do
    context 'when deleting an existing promo' do
      let(:existing_promo) { create :promo }
      it 'returns a 200' do
        delete api_v1_promo_path(existing_promo.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when deleting a non-existing promo' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          delete api_v1_promo_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
