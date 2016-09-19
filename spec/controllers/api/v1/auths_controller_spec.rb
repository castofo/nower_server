require 'rails_helper'

RSpec.describe Api::V1::AuthsController, type: :controller do

  let(:valid_session) { {} }

  describe 'POST #login' do
    let(:existing_user) { create :user }
    it 'assigns the requested user as @user' do
      post :login, params: { email: existing_user.email }, session: valid_session
      expect(assigns(:user)).to eq(existing_user)
    end
  end
end
