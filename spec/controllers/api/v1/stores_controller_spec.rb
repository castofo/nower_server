require 'rails_helper'

RSpec.describe Api::V1::StoresController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:store)
  }

  let(:invalid_attributes) {
    attributes_for(:store, name: nil)
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all stores as @stores" do
      store = Store.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:stores)).to eq([store])
    end
  end

  describe "GET #show" do
    it "assigns the requested store as @store" do
      store = Store.create! valid_attributes
      get :show, params: {id: store.to_param}, session: valid_session
      expect(assigns(:store)).to eq(store)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Store" do
        expect {
          post :create, params: {store: valid_attributes}, session: valid_session
        }.to change(Store, :count).by(1)
      end

      it "assigns a newly created store as @store" do
        post :create, params: {store: valid_attributes}, session: valid_session
        expect(assigns(:store)).to be_a(Store)
        expect(assigns(:store)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved store as @store" do
        post :create, params: {store: invalid_attributes}, session: valid_session
        expect(assigns(:store)).to be_a_new(Store)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:store, description: "My new description")
      }

      it "updates the requested store" do
        store = Store.create! valid_attributes
        put :update, params: {id: store.to_param, store: new_attributes}, session: valid_session
        store.reload
        expect(store.description).to eq "My new description"
      end

      it "assigns the requested store as @store" do
        store = Store.create! valid_attributes
        put :update, params: {id: store.to_param, store: valid_attributes}, session: valid_session
        expect(assigns(:store)).to eq(store)
      end
    end

    context "with invalid params" do
      it "assigns the store as @store" do
        store = Store.create! valid_attributes
        put :update, params: {id: store.to_param, store: invalid_attributes}, session: valid_session
        expect(assigns(:store)).to eq(store)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested store" do
      store = Store.create! valid_attributes
      expect {
        delete :destroy, params: {id: store.to_param}, session: valid_session
      }.to change(Store, :count).by(-1)
    end
  end
end
