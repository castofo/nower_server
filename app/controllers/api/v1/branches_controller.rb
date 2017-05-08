module Api::V1
  class BranchesController < ApplicationController
    before_action :set_branch, only: [:show]

    # GET /branches
    def index
      if params[:latitude].blank? || params[:longitude].blank?
        @branches = Branch.all
      else
        @branches = Branch.near([params[:latitude], params[:longitude]],
                                Constants::Branch::DEFAULT_BRANCH_NEARNESS_KM,
                                units: :km)
      end

      render json: @branches
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
