require 'rails_helper'

RSpec.describe Api::V1::ContactInformationsController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:contact_information)
  }

  let(:invalid_attributes) {
    attributes_for(:contact_information, key: nil)
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all contact_informations as @contact_informations" do
      contact_information = ContactInformation.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:contact_informations)).to eq([contact_information])
    end
  end

  describe "GET #show" do
    it "assigns the requested contact_information as @contact_information" do
      contact_information = ContactInformation.create! valid_attributes
      get :show, params: {id: contact_information.to_param}, session: valid_session
      expect(assigns(:contact_information)).to eq(contact_information)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new ContactInformation" do
        expect {
          post :create, params: {contact_information: valid_attributes}, session: valid_session
        }.to change(ContactInformation, :count).by(1)
      end

      it "assigns a newly created contact_information as @contact_information" do
        post :create, params: {contact_information: valid_attributes}, session: valid_session
        expect(assigns(:contact_information)).to be_a(ContactInformation)
        expect(assigns(:contact_information)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved contact_information as @contact_information" do
        post :create, params: {contact_information: invalid_attributes}, session: valid_session
        expect(assigns(:contact_information)).to be_a_new(ContactInformation)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:contact_information, value: "My new value")
      }

      it "updates the requested contact_information" do
        contact_information = ContactInformation.create! valid_attributes
        put :update, params: {id: contact_information.to_param, contact_information: new_attributes}, session: valid_session
        contact_information.reload
        expect(contact_information.value).to eq("My new value")
      end

      it "assigns the requested contact_information as @contact_information" do
        contact_information = ContactInformation.create! valid_attributes
        put :update, params: {id: contact_information.to_param, contact_information: valid_attributes}, session: valid_session
        expect(assigns(:contact_information)).to eq(contact_information)
      end
    end

    context "with invalid params" do
      it "assigns the contact_information as @contact_information" do
        contact_information = ContactInformation.create! valid_attributes
        put :update, params: {id: contact_information.to_param, contact_information: invalid_attributes}, session: valid_session
        expect(assigns(:contact_information)).to eq(contact_information)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested contact_information" do
      contact_information = ContactInformation.create! valid_attributes
      expect {
        delete :destroy, params: {id: contact_information.to_param}, session: valid_session
      }.to change(ContactInformation, :count).by(-1)
    end
  end
end
