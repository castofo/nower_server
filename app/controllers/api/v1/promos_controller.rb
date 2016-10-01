module Api::V1
  class PromosController < ApplicationController
    include Swagger::Docs::ImpotentMethods

    before_action :set_promo, only: [:show, :update, :destroy]

    swagger_controller :promos, 'Promos'

    swagger_api :index do
      summary 'Fetches all Promos'
      notes 'This lists all the promos'
      response :ok
      response :unauthorized
      type :index_response
    end

    swagger_model :index_response do
       property :promos, :array, :required, 'List of promos', { items: { "$ref" => "promo" } }
    end

    # GET /promos
    def index
      @promos = Promo.all

      render json: @promos
    end

    # GET /promos/1
    def show
      render json: @promo
    end

    swagger_model :promo do
      description "A Promo object."
      property :name, :string, :required, 'Name of the promo'
      property :description, :text, :required, 'Description of the promo'
      property :terms, :text, :required, 'Terms and condition for the promo'
      property :stock, :integer, 'Stock for the promo (available items)'
      property :price, :double, 'Price of each item related with the promo'
      property :start_date, :date, 'Start date of the promo'
      property :end_date, :date, 'End date of the promo'
    end

    swagger_api :create do
      summary 'Creates a new promo'
      param :body, :body, :promo, :required, 'Promo to be created'
      response :created
      response :unauthorized
      response :unprocessable_entity
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
            :end_date
        )
      end
  end
end
