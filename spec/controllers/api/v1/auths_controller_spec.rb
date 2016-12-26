require 'rails_helper'

RSpec.describe Api::V1::AuthsController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:user)
  }

  let(:invalid_attributes) {
    attributes_for(:user, first_name: nil)
  }

  let(:valid_session) { {} }

  describe 'POST #login' do
    let(:existing_user) { create :user }
    it 'assigns the requested user as @user' do
      post :login, params: { email: existing_user.email }, session: valid_session
      expect(assigns(:user)).to eq(existing_user)
    end
  end

  describe "POST #register" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :register, params: valid_attributes, session: valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :register, params: valid_attributes, session: valid_session
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :register, params: invalid_attributes, session: valid_session
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end
