require 'rails_helper'

RSpec.describe Api::V1::AdminsController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:admin)
  }

  let(:invalid_attributes) {
    attributes_for(:admin, password: nil)
  }

  let(:valid_session) { {} }

  describe 'POST #login' do
    let(:existing_admin) { create :admin }
    it 'assigns the requested admin as @admin' do
      post :login, params: { email: existing_admin.email }, session: valid_session
      expect(assigns(:admin)).to eq(existing_admin)
    end
  end

  describe "POST #register" do
    context "with valid params" do
      it "creates a new Admin" do
        expect {
          post :register, params: valid_attributes, session: valid_session
        }.to change(Admin, :count).by(1)
      end

      it "assigns a newly created admin as @admin" do
        post :register, params: valid_attributes, session: valid_session
        expect(assigns(:admin)).to be_a(Admin)
        expect(assigns(:admin)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved admin as @admin" do
        post :register, params: invalid_attributes, session: valid_session
        expect(assigns(:admin)).to be_a_new(Admin)
      end
    end
  end
end
