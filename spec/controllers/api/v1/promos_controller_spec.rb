require 'rails_helper'

RSpec.describe Api::V1::PromosController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:promo)
  }

  let(:invalid_attributes) {
    attributes_for(:promo, name: nil)
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all promos as @promos" do
      promo = Promo.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:promos)).to eq([promo])
    end
  end

  describe "GET #show" do
    it "assigns the requested promo as @promo" do
      promo = Promo.create! valid_attributes
      get :show, params: {id: promo.to_param}, session: valid_session
      expect(assigns(:promo)).to eq(promo)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Promo" do
        expect {
          post :create, params: {promo: valid_attributes}, session: valid_session
        }.to change(Promo, :count).by(1)
      end

      it "assigns a newly created promo as @promo" do
        post :create, params: {promo: valid_attributes}, session: valid_session
        expect(assigns(:promo)).to be_a(Promo)
        expect(assigns(:promo)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved promo as @promo" do
        post :create, params: {promo: invalid_attributes}, session: valid_session
        expect(assigns(:promo)).to be_a_new(Promo)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:promo_with_dates, description: "My new description")
      }

      it "updates the requested promo" do
        promo = Promo.create! valid_attributes
        put :update, params: {id: promo.to_param, promo: new_attributes}, session: valid_session
        promo.reload
        expect(promo.description).to eq("My new description")
      end

      it "assigns the requested promo as @promo" do
        promo = Promo.create! valid_attributes
        put :update, params: {id: promo.to_param, promo: valid_attributes}, session: valid_session
        expect(assigns(:promo)).to eq(promo)
      end
    end

    context "with invalid params" do
      it "assigns the promo as @promo" do
        promo = Promo.create! valid_attributes
        put :update, params: {id: promo.to_param, promo: invalid_attributes}, session: valid_session
        expect(assigns(:promo)).to eq(promo)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested promo" do
      promo = Promo.create! valid_attributes
      expect {
        delete :destroy, params: {id: promo.to_param}, session: valid_session
      }.to change(Promo, :count).by(-1)
    end
  end
end
