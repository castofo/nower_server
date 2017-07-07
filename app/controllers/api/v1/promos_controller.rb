module Api::V1
  class PromosController < ApplicationController
    include Expandable
    expandable_attrs :branches
    wrap_parameters include: Promo.attribute_names + [:branch_ids]

    before_action :set_promo, only: [:show, :update, :destroy]

    # GET /promos
    def index
      if params[:branch_id].blank?
        @promos = Promo.all
      else
        @promos = Branch.find(params[:branch_id]).promos
      end

      render json: @promos, include: expand_attrs
    end

    # GET /promos/1
    def show
      render json: @promo, include: expand_attrs
    end

    # POST /promos
    def create
      @promo = Promo.new(promo_params)

      if @promo.save
        render json: @promo, status: :created
      else
        render json: @promo.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /promos/1
    def update
      if @promo.update(promo_params)
        render json: @promo
      else
        render json: @promo.errors, status: :unprocessable_entity
      end
    end

    # DELETE /promos/1
    def destroy
      if @promo.destroy
        render json: { success: true }
      else
        renser json: @promo.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_promo
        @promo = Promo.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def promo_params
        params.require(:promo).permit(
            :name,
            :description,
            :terms,
            :stock,
            :price,
            :start_date,
            :end_date,
            branch_ids: []
        )
      end
  end
end
