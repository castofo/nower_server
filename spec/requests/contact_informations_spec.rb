require 'rails_helper'

RSpec.describe "ContactInformations", type: :request do
  describe "GET /v1/contact_informations" do
    context 'when there is no contact informations' do
      it 'returns an empty array' do
        sub_get api_v1_contact_informations_path
        expect(response).to have_http_status(200)
        contact_informations = JSON.parse(response.body)
        expect(contact_informations).to be_a_kind_of Array
        expect(contact_informations).to be_empty
      end
    end

    context 'when there is a contact_information' do
      let!(:existing_contact_information) { create :contact_information }
      it 'returns an array with the contact_information' do
        sub_get api_v1_contact_informations_path
        expect(response).to have_http_status(200)
        contact_informations = JSON.parse(response.body)
        expect(contact_informations.length).to eq 1
        expect(contact_informations.first['id']).to eq existing_contact_information.id
        expect(contact_informations.first['key']).to eq existing_contact_information.key
        expect(contact_informations.first['value']).to eq existing_contact_information.value
      end
    end

    context "when 'store_id' query param is included" do
      let(:existing_store) { create :store }
      let(:associated_count) { rand(5..10) }

      # Create contact_informations associated to existing store
      before do
        associated_count.times { create(:contact_information, store_id: existing_store.id) }
      end

      # Create some other contact_informations that are not associated to existing store
      before do
        rand(5..10).times { create(:contact_information) }
      end

      it 'returns only contact_informations that belong to the given store' do
        sub_get api_v1_contact_informations_path, { params: { store_id: existing_store.id } }
        expect(response).to have_http_status(200)
        contact_informations = JSON.parse(response.body)
        expect(contact_informations.length).to eq associated_count
        contact_informations.each do |contact_information|
          expect(contact_information['store_id']).to eq existing_store.id
        end
      end
    end

    context "when 'expand' query param contains 'store'" do
      before do
        rand(5..10).times { create :contact_information }
      end

      it 'returns contact_informations with embedded store entity' do
        sub_get api_v1_contact_informations_path, { params: { expand: :store } }
        expect(response).to have_http_status(200)
        contact_informations = JSON.parse(response.body)
        contact_informations.each do |contact_information|
          expect(contact_information['store']).not_to be_nil
        end
      end
    end

    context "when 'expand' query param contains 'branches'" do
      # Create some contact_informations with branches
      before do
        rand(5..10).times do
          contact_information = create :contact_information
          store = contact_information.store
          rand(5..10).times do
            contact_information.branches.push(create :branch, store_id: store.id)
          end
        end
      end

      it 'returns contact_informations with embedded branches entities' do
        sub_get api_v1_contact_informations_path, { params: { expand: :branches } }
        expect(response).to have_http_status(200)
        contact_informations = JSON.parse(response.body)
        contact_informations.each do |contact_information|
          expect(contact_information['branches']).not_to be_nil
          expect(contact_information['branches']).to be_a_kind_of(Array)
        end
      end
    end
  end

  describe 'GET /v1/contact_informations/:id' do
    let(:existing_contact_information) { create :contact_information }
    context 'when id is valid' do
      it 'returns the contact_information' do
        sub_get api_v1_contact_information_path(existing_contact_information.id)
        expect(response).to have_http_status(200)
        found_contact_information = JSON.parse(response.body)
        expect(found_contact_information['id']).to eq existing_contact_information.id
        expect(found_contact_information['key']).to eq existing_contact_information.key
        expect(found_contact_information['value']).to eq existing_contact_information.value
      end
    end

    context "when 'expand' query param contains 'store'" do
      it 'returns the contact_information with embedded store entity' do
        sub_get api_v1_contact_information_path(existing_contact_information.id), {
          params: { expand: :store }
        }
        expect(response).to have_http_status(200)
        found_contact_information = JSON.parse(response.body)
        expect(found_contact_information['store']['id']).to eq existing_contact_information.store.id
      end
    end

    context "when 'expand' query param contains 'branches'" do
      let(:branches_count) { rand(5..10) }
      before do
        branches_count.times do
          existing_contact_information.branches.push(create :branch)
        end
      end
      it 'returns the contact_information with embedded branches entities' do
        sub_get api_v1_contact_information_path(existing_contact_information.id), {
          params: { expand: :branches }
        }
        expect(response).to have_http_status(200)
        found_contact_information = JSON.parse(response.body)
        expect(found_contact_information['branches']).not_to be_nil
        expect(found_contact_information['branches']).to be_a_kind_of(Array)
        expect(found_contact_information['branches'].length).to eq branches_count
      end
    end

    context 'when id is invalid' do
      it 'raises a RecordNotFound' do
        expect do
          sub_get api_v1_contact_information_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /v1/contact_informations' do
    let(:body) { attributes_for :contact_information }
    context 'when all attributes are valid' do
      it 'creates the contact_information' do
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(201)
        created_contact_information = JSON.parse(response.body)
        expect(created_contact_information['key']).to eq body[:key]
        expect(created_contact_information['value']).to eq body[:value]
      end
    end

    context 'when key is not present' do
      it 'returns a 422' do
        body[:key] = nil
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when key is empty' do
      it 'returns a 422' do
        body[:key] = ''
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when key already exist in the store' do
      let(:existing) { create :contact_information }
      it 'returns a 422' do
        body[:key] = existing.key
        body[:store_id] = existing.store_id
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when value is not present' do
      it 'returns a 422' do
        body[:value] = nil
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when value is empty' do
      it 'returns a 422' do
        body[:value] = ''
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when store_id is not present' do
      it 'returns a 422' do
        body[:store_id] = nil
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when store_id is empty' do
      it 'returns a 422' do
        body[:store_id] = ''
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when store_id is non-existing store id' do
      it 'returns a 422' do
        body[:store_id] = Faker::Lorem.word
        sub_post api_v1_contact_informations_path, { params: { contact_information: body } }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /v1/contact_informations' do
    let(:existing_contact_information) { create :contact_information }
    let(:body) do
      { key: Faker::App.name, value: Faker::Lorem.word }
    end
    context 'when updating an existing contact_information' do
      context 'when new attributes are valid' do
        it 'updates the contact_information' do
          sub_put api_v1_contact_information_path(existing_contact_information.id), {
            params: { contact_information: body }
          }
          expect(response).to have_http_status(200)
          updated_contact_information = JSON.parse(response.body)
          expect(updated_contact_information['key']).to eq body[:key]
          expect(updated_contact_information['value']).to eq body[:value]
        end
      end

      context 'when key is nil' do
        it 'returns a 422' do
          body[:key] = nil
          sub_put api_v1_contact_information_path(existing_contact_information.id), {
            params: { contact_information: body }
          }
          expect(response).to have_http_status(422)
        end
      end

      context 'when key is empty' do
        it 'returns a 422' do
          body[:key] = ''
          sub_put api_v1_contact_information_path(existing_contact_information.id), {
            params: { contact_information: body }
          }
          expect(response).to have_http_status(422)
        end
      end

      context 'when key already exist in the store' do
        before do
          create(:contact_information, key: body[:key],
                                       store_id: existing_contact_information.store.id)
        end
        it 'returns a 422' do
          sub_put api_v1_contact_information_path(existing_contact_information.id), {
            params: { contact_information: body }
          }
          expect(response).to have_http_status(422)
        end
      end

      context 'when value is nil' do
        it 'returns a 422' do
          body[:value] = nil
          sub_put api_v1_contact_information_path(existing_contact_information.id), {
            params: { contact_information: body }
          }
          expect(response).to have_http_status(422)
        end
      end

      context 'when value is empty' do
        it 'returns a 422' do
          body[:value] = ''
          sub_put api_v1_contact_information_path(existing_contact_information.id), {
            params: { contact_information: body }
          }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when updating a non-existing contact_information' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_put api_v1_contact_information_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /v1/contact_informations' do
    context 'when deleting an existing contact_information' do
      let(:existing_contact_information) { create :contact_information }
      it 'returns a 200' do
        sub_delete api_v1_contact_information_path(existing_contact_information.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when deleting a non-existing contact_information' do
      it 'raises a RecordNotFound' do
        expect do
          sub_delete api_v1_contact_information_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
