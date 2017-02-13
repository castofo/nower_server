require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  describe 'POST /v1/admins/login' do
    let(:password) { Faker::Internet.password }
    let(:existing_admin) { create(:admin, password: password) }
    let(:body) do
      { email: existing_admin.email, password: password }
    end
    context 'when email and password are valid' do
      it 'responds with 200' do
        sub_post api_v1_admins_login_path, { params: body }
        expect(response).to have_http_status(200)
      end

      it 'responds with an authorization token' do
        sub_post api_v1_admins_login_path, { params: body }
        auth_response = JSON.parse(response.body)
        expect(auth_response['token']).to be_kind_of String
        expect(auth_response['token']).not_to be_empty
      end

      it 'responds with the admin id' do
        sub_post api_v1_admins_login_path, { params: body }
        auth_response = JSON.parse(response.body)
        expect(auth_response['admin_id']).to eq existing_admin.id
      end
    end

    context 'when email does not exist' do
      it 'responds with 401' do
        sub_post api_v1_admins_login_path, { params: { email: 'non-existing-email@email.co' } }
        expect(response).to have_http_status(401)
      end
    end

    context 'when password is incorrect' do
      let(:wrong_pass_body) do
        { email: existing_admin.email, password: password[0..-2] } # Ignore last char from password.
      end
      it 'responds with 401' do
        sub_post api_v1_admins_login_path, { params: wrong_pass_body }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /v1/admins/register' do
    let(:body) { attributes_for :admin }
    context 'when all attributes are valid' do
      it 'creates the admin' do
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
        created_admin = JSON.parse(response.body)
        expect(created_admin['email']).to eq body[:email]
        expect(created_admin['privileges']).to eq body[:privileges]
      end
    end

    context 'when email is not present' do
      it 'returns a 422' do
        body[:email] = nil
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email is empty' do
      it 'returns a 422' do
        body[:email] = ''
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email already exists' do
      let(:existing_admin) { create :admin }
      it 'returns a 422' do
        body[:email] = existing_admin.email
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email has invalid format' do
      it 'returns a 422' do
        body[:email] = Faker::Lorem.sentence
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password is not present' do
      it 'returns a 422' do
        body[:password] = nil
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password is empty' do
      it 'returns a 422' do
        body[:password] = ''
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password has less than 8 characters' do
      it 'returns a 422' do
        body[:password] = Faker::Internet.password(1, 7)
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password has exactly 8 characters' do
      it 'creates the admin' do
        body[:password] = Faker::Internet.password(8, 8)
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
      end
    end

    context 'when password has more than 8 characters' do
      it 'creates the admin' do
        body[:password] = Faker::Internet.password(9)
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
      end
    end

    context 'when privileges is not present' do
      it 'returns a 201' do
        body[:privileges] = nil # Will default to []
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
      end
    end

    context 'when privileges is empty' do
      it 'returns a 201' do
        body[:privileges] = '' # Will default to []
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
      end
    end

    context 'when privileges is not an array' do
      it 'returns a 201' do
        body[:privileges] = Faker::Lorem.word # Will default to []
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
      end
    end

    context 'when privileges is an array' do
      it 'creates the admin' do
        body[:privileges] = []
        sub_post api_v1_admins_register_path, { params: body }
        expect(response).to have_http_status(201)
      end
    end
  end
end
