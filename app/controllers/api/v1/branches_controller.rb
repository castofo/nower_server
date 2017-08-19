module Api::V1
  class BranchesController < ApplicationController
    include Expandable
    expandable_attrs :store, :promos, :contact_informations

    before_action :set_branch, only: [:show, :update, :destroy]

    # GET /branches
    def index
      @branches = Branch.all

      @branches = @branches.store_id(params[:store_id]) unless params[:store_id].blank?
      unless params[:latitude].blank? || params[:longitude].blank?
        @branches = @branches.geolocated(params[:latitude], params[:longitude])
      end

      render json: @branches, include: expand_attrs
    end

    # GET /branches/1
    def show
      render json: @branch, include: expand_attrs
    end

    # POST /branches
    def create
      @branch = Branch.new(branch_params)

      if @branch.save
        render json: @branch, status: :created
      else
        render json: @branch.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /branches/1
    def update
      if @branch.update(branch_params)
        render json: @branch
      else
        render json: @branch.errors, status: :unprocessable_entity
      end
    end

    # DELETE /branches/1
    def destroy
      if @branch.destroy
        render json: { success: true }
      else
        render json: @branch.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_branch
        @branch = Branch.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def branch_params
        params.require(:branch).permit(
            :name,
            :latitude,
            :longitude,
            :address,
            :default_contact_info,
            :store_id
        )
      end
  end
end
