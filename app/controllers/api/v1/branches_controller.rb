module Api::V1
  class BranchesController < ApplicationController
    before_action :set_branch, only: [:show]

    # GET /branches
    def index
      render json: Branch.all
    end

    # GET /branches/1
    def show
      render json: @branch
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_branch
        @branch = Branch.find(params[:id])
      end
  end
end
