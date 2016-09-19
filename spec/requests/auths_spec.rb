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
end
