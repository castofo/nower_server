require 'rails_helper'

RSpec.describe 'Auths', type: :request do
  describe 'POST /v1/auths/login' do
    let(:password) { Faker::Internet.password }
    let(:existing_user) { create(:user, password: password) }
    let(:body) { { email: existing_user.email, password: password } }
    context 'when email and password are valid' do
      it 'responds with 200' do
        sub_post api_v1_auths_login_path, { params: body }
        expect(response).to have_http_status(200)
      end

      it 'responds with an authorization token' do
        sub_post api_v1_auths_login_path, { params: body }
        auth_response = JSON.parse(response.body)
        expect(auth_response['token']).to be_kind_of String
        expect(auth_response['token']).not_to be_empty
      end

      it 'responds with the user id' do
        sub_post api_v1_auths_login_path, { params: body }
        auth_response = JSON.parse(response.body)
        expect(auth_response['user_id']).to eq existing_user.id
      end
    end

    context 'when email does not exist' do
      it 'responds with 401' do
        sub_post api_v1_auths_login_path, { params: { email: 'non-existing-email@email.co' } }
        expect(response).to have_http_status(401)
      end
    end

    context 'when password is incorrect' do
      let(:wrong_pass_body) do
        { email: existing_user.email, password: password[0..-2] } # Ignore last char from password.
      end
      it 'responds with 401' do
        sub_post api_v1_auths_login_path, { params: wrong_pass_body }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /v1/auths/register' do
    let(:body) { attributes_for :user }
    context 'when all attributes are valid' do
      it 'creates the user' do
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(201)
        created_user = JSON.parse(response.body)
        expect(created_user['first_name']).to eq body[:first_name]
        expect(created_user['last_name']).to eq body[:last_name]
      end
    end

    context 'when first_name is not present' do
      it 'returns a 422' do
        body[:first_name] = nil
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when first_name is empty' do
      it 'returns a 422' do
        body[:first_name] = ''
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when last_name is not present' do
      it 'returns a 422' do
        body[:last_name] = nil
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when last_name is empty' do
      it 'returns a 422' do
        body[:last_name] = ''
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email is not present' do
      it 'returns a 422' do
        body[:email] = nil
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email is empty' do
      it 'returns a 422' do
        body[:email] = ''
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email already exists' do
      let(:existing_user) { create :user }
      it 'returns a 422' do
        body[:email] = existing_user.email
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when email has invalid format' do
      it 'returns a 422' do
        body[:email] = Faker::Lorem.sentence
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when gender is not present' do
      it 'creates the user' do
        body[:gender] = nil
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when gender is empty' do
      it 'returns a 422' do
        body[:gender] = ''
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when gender is not F nor M' do
      it 'returns a 422' do
        invalid_chars = ('A'..'Z').to_a - ['F', 'M']
        body[:gender] = invalid_chars.sample
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password is not present' do
      it 'returns a 422' do
        body[:password] = nil
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password is empty' do
      it 'returns a 422' do
        body[:password] = ''
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password has less than 8 characters' do
      it 'returns a 422' do
        body[:password] = Faker::Internet.password(1, 7)
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when password has exactly 8 characters' do
      it 'creates the user' do
        body[:password] = Faker::Internet.password(8, 8)
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when password has more than 8 characters' do
      it 'creates the user' do
        body[:password] = Faker::Internet.password(9)
        sub_post api_v1_auths_register_path, { params: { user: body } }
        expect(response).to have_http_status(201)
      end
    end
  end
end
