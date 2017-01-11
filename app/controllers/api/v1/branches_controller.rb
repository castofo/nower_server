module Api::V1
  class BranchesController < ApplicationController
    include Swagger::Docs::ImpotentMethods

    swagger_controller :branches, 'Branches Management'

    swagger_model :index_response do
       property :branches, :array, 'List of branches', { items: { "$ref" => "branch" } }
    end

    swagger_api :index do
      summary 'Fetches all Branches'
      response :ok
      response :unauthorized
      type :index_response
    end

    # GET branches
    def index
      render json: Branch.all
    end
  end
end
