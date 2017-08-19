module Api::V1
  class ContactInformationsController < ApplicationController
    include Expandable
    expandable_attrs :branches, :store
    wrap_parameters include: ContactInformation.attribute_names + [:branch_ids]

    before_action :set_contact_information, only: [:show, :update, :destroy]

    # GET /contact_informations
    def index
      @contact_informations = ContactInformation.all

      @contact_informations = @contact_informations.store_id(params[:store_id]) unless params[:store_id].blank?
      @contact_informations = @contact_informations.branch_id(params[:branch_id]) unless params[:branch_id].blank?

      render json: @contact_informations, include: expand_attrs
    end

    # GET /contact_informations/1
    def show
      render json: @contact_information, include: expand_attrs
    end

    # POST /contact_informations
    def create
      @contact_information = ContactInformation.new(contact_information_params)

      if @contact_information.save
        render json: @contact_information, status: :created
      else
        render json: @contact_information.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /contact_informations/1
    def update
      if @contact_information.update(contact_information_params)
        render json: @contact_information
      else
        render json: @contact_information.errors, status: :unprocessable_entity
      end
    end

    # DELETE /contact_informations/1
    def destroy
      if @contact_information.destroy
        render json: { success: true }
      else
        render json: @contact_information.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_contact_information
        @contact_information = ContactInformation.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def contact_information_params
        params.require(:contact_information).permit(
            :key,
            :value,
            :store_id,
            branch_ids: []
        )
      end
  end
end
