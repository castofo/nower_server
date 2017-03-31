module Api::V1
  class BranchesController < ApplicationController

    # GET branches
    def index
      render json: Branch.all
    end
  end
end
