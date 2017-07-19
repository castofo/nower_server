module Api::V1
  class StoresController < ApplicationController
    include Expandable
    expandable_attrs :branches

    before_action :set_store, only: [:show, :update, :destroy]

    # GET /stores
    def index
      @stores = Store.all

      render json: @stores, include: expand_attrs
    end

    # GET /stores/1
    def show
      render json: @store, include: expand_attrs
    end

    # POST /stores
    def create
      @store = Store.new(store_params)

      if @store.save
        render json: @store, status: :created
      else
        render json: @store.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /stores/1
    def update
      if @store.update(store_params)
        render json: @store
      else
        render json: @store.errors, status: :unprocessable_entity
      end
    end

    # DELETE /stores/1
    def destroy
      if @store.destroy
        render json: { success: true }
      else
        render json: @promo.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_store
        @store = Store.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def store_params
        params.require(:store).permit(
            :name,
            :description,
            :nit,
            :website,
            :address
        )
      end
  end
end
