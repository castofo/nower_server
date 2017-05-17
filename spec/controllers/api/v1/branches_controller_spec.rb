require 'rails_helper'

RSpec.describe Api::V1::BranchesController, type: :controller do

  let(:valid_attributes) {
    attributes_for(:branch)
  }

  let(:invalid_attributes) {
    attributes_for(:branch, name: nil)
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "assigns the requested branch as @branch" do
      branch = Branch.create! valid_attributes
      get :show, params: {id: branch.to_param}, session: valid_session
      expect(assigns(:branch)).to eq(branch)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Branch" do
        expect {
          post :create, params: {branch: valid_attributes}, session: valid_session
        }.to change(Branch, :count).by(1)
      end

      it "assigns a newly created branch as @branch" do
        post :create, params: {branch: valid_attributes}, session: valid_session
        expect(assigns(:branch)).to be_a(Branch)
        expect(assigns(:branch)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved branch as @branch" do
        post :create, params: {branch: invalid_attributes}, session: valid_session
        expect(assigns(:branch)).to be_a_new(Branch)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:branch, name: "My new name")
      }

      it "updates the requested branch" do
        branch = Branch.create! valid_attributes
        put :update, params: {id: branch.to_param, branch: new_attributes}, session: valid_session
        branch.reload
        expect(branch.name).to eq("My new name")
      end

      it "assigns the requested branch as @branch" do
        branch = Branch.create! valid_attributes
        put :update, params: {id: branch.to_param, branch: valid_attributes}, session: valid_session
        expect(assigns(:branch)).to eq(branch)
      end
    end

    context "with invalid params" do
      it "assigns the branch as @branch" do
        branch = Branch.create! valid_attributes
        put :update, params: {id: branch.to_param, branch: invalid_attributes},
                     session: valid_session
        expect(assigns(:branch)).to eq(branch)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested branch" do
      branch = Branch.create! valid_attributes
      expect {
        delete :destroy, params: {id: branch.to_param}, session: valid_session
      }.to change(Branch, :count).by(-1)
    end
  end
end
