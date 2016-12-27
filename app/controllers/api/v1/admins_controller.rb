module Api::V1
  class AdminsController < ApplicationController
    include Swagger::Docs::ImpotentMethods

    before_action :set_admin, only: [:login]

    swagger_controller :admins, "Admins Management"

    swagger_api :index do
      summary 'Fetches all web admins (Development only)'
      response :ok
    end

    # GET admins/index
    # TODO: Remove this, development purposes.
    def index
      render json: Admin.all
    end

    swagger_model :login_response do
      description "A login response."
      property :admin_id, :uuid, 'Id of the logged admin'
      property :token, :string, 'Authorization token for subsequent requests'
    end

    swagger_model :login_body do
      description "A login request body."
      property :email, :string, :required, 'Email of the admin to be logged in'
      property :password, :string, :required, 'Password of the admin to be logged in'
    end

    swagger_api :login do
      summary 'Logs in an application admin'
      param :body, :body, :login_body, :required, 'Login request body'
      response :ok
      response :unauthorized
      type :login_response
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

    swagger_model :register_response do
      description "The created admin."
      property :id, :uuid, 'Id of the created admin'
      property :email, :string, 'Email of the admin'
      property :admin_type, :string, 'Type of admin'
      property :privileges, :integer, 'Privileges of the admin'
      property :activated_at, :date, 'Activation date of the admin (null -> not activated)'
    end

    swagger_model :register_body do
      description "Parameters of Admin to be created."
      property :email, :string, :required, 'Email of the admin'
      property :password, :string, :required, 'Password of the admin'
      property :privileges, :integer, 'Privileges of the admin'
    end

    swagger_api :register do
      summary 'Registers an application admin'
      param :body, :body, :register_body, :required, 'Register request body'
      response :created
      response :bad_request
      response :unauthorized
      response :unprocessable_entity
      type :register_response
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
            :email,
            :password,
            :privileges,
            :admin_type # Only used in tests, check :before_save in model
        )
      end
  end
end
