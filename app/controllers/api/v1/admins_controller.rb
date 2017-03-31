module Api::V1
  class AdminsController < ApplicationController
    before_action :set_admin, only: [:login]

    # GET admins/index
    # TODO: Remove this, development purposes.
    def index
      render json: Admin.all
    end

    # POST admins/login
    def login
      if @admin
        auth_token = @admin.login(params[:password])
        if auth_token
          render json: { admin_id: @admin.id, token: auth_token }, status: :ok
          return
        end
      else
        @admin = Admin.new
        @admin.errors.add(:email, :unregistered)
      end
      render json: @admin.errors, status: :unauthorized
    end

    # POST admins/register
    def register
      @admin = Admin.new(admin_params)

      if @admin.save
        render json: @admin, status: :created
      else
        render json: @admin.errors, status: :unprocessable_entity
      end
    end

    private

      def set_admin
        @admin = Admin.find_by_email(params[:email])
      end

      # Only allow a trusted parameter "white list" through.
      def admin_params
        params.permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :admin_type, # Only used in tests, check :before_save in model
            privileges: []
        )
      end
  end
end
