require 'rails_helper'

RSpec.describe 'Branches', type: :request do
  describe 'GET /v1/branches' do
    context 'when there is no branches' do
      it 'returns an empty array' do
        sub_get api_v1_branches_path
        expect(response).to have_http_status(200)
        branches = JSON.parse(response.body)
        expect(branches).to be_a_kind_of Array
        expect(branches).to be_empty
      end
    end

    context 'when there is a branch' do
      let!(:existing_branch) { create :branch }
      it 'returns an array with the branch' do
        sub_get api_v1_branches_path
        expect(response).to have_http_status(200)
        branches = JSON.parse(response.body)
        expect(branches.length).to eq 1
        expect(branches.first['id']).to eq existing_branch.id
        expect(branches.first['name']).to eq existing_branch.name
        expect(branches.first['address']).to eq existing_branch.address
      end
    end
  end

  describe 'GET /v1/branches/:id' do
    let(:existing_branch) { create :branch }
    context 'when id is valid' do
      it 'returns the branch' do
        sub_get api_v1_branch_path(existing_branch.id)
        expect(response).to have_http_status(200)
        found_branch = JSON.parse(response.body)
        expect(found_branch['id']).to eq existing_branch.id
        expect(found_branch['name']).to eq existing_branch.name
        expect(found_branch['address']).to eq existing_branch.address
      end
    end

    context 'when id is invalid' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_get api_v1_branch_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /v1/branches' do
    let(:body) { attributes_for :branch }
    context 'when all attributes are valid' do
      it 'creates the branch' do
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(201)
        created_branch = JSON.parse(response.body)
        expect(created_branch['name']).to eq body[:name]
        expect(created_branch['address']).to eq body[:address]
      end
    end

    context 'when name is not present' do
      it 'returns a 422' do
        body[:name] = nil
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when name is empty' do
      it 'returns a 422' do
        body[:name] = ''
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when name has more then 35 characters' do
      it 'returns a 422' do
        body[:name] = Faker::Lorem.characters(36)
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when latitude is not present' do
      it 'returns a 422' do
        body[:latitude] = nil
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when latitude is empty' do
      it 'returns a 422' do
        body[:latitude] = ''
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when longitude is not present' do
      it 'returns a 422' do
        body[:longitude] = nil
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when longitude is empty' do
      it 'returns a 422' do
        body[:longitude] = ''
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when address is not present' do
      it 'returns a 422' do
        body[:address] = nil
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when address is empty' do
      it 'returns a 422' do
        body[:address] = ''
        sub_post api_v1_branches_path, { params: { branch: body } }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /v1/branches' do
    let(:existing_branch) { create :branch }
    let(:body) do
      { name: Faker::Address.street_name, address: Faker::Address.street_address }
    end
    context 'when updating an existing branch' do
      context 'when new name is valid' do
        it 'updates the branch' do
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(200)
          updated_branch = JSON.parse(response.body)
          expect(updated_branch['name']).to eq body[:name]
          expect(updated_branch['address']).to eq body[:address]
        end
      end

      context 'when name is nil' do
        it 'returns a 422' do
          body[:name] = nil
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when name is empty' do
        it 'returns a 422' do
          body[:name] = ''
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when name has more then 35 characters' do
        it 'returns a 422' do
          body[:name] = Faker::Lorem.characters(36)
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when address is nil' do
        it 'returns a 422' do
          body[:address] = nil
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when address is empty' do
        it 'returns a 422' do
          body[:address] = ''
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when latitude is nil' do
        it 'returns a 422' do
          body[:latitude] = nil
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when latitude is empty' do
        it 'returns a 422' do
          body[:latitude] = ''
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when longitude is nil' do
        it 'returns a 422' do
          body[:longitude] = nil
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when longitude is empty' do
        it 'returns a 422' do
          body[:longitude] = ''
          sub_put api_v1_branch_path(existing_branch.id), { params: { branch: body } }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when updating a non-existing branch' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_put api_v1_branch_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /v1/branches' do
    context 'when deleting an existing branch' do
      let(:existing_branch) { create :branch }
      it 'returns a 200' do
        sub_delete api_v1_branch_path(existing_branch.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when deleting a non-existing branch' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_delete api_v1_branch_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
