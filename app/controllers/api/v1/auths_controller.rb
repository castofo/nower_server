module Api::V1
  class AuthsController < ApplicationController
    include Swagger::Docs::ImpotentMethods

    before_action :set_user, only: [:login]

    swagger_controller :auths, "Authorization Management"

    swagger_api :index do
      summary 'Fetches all application users (Development only)'
      response :ok
    end

    # GET auths/index
    # TODO: Remove this, development purposes.
    def index
      render json: User.all
    end

    swagger_model :login_response do
      description "A Login response."
      property :user_id, :uuid, 'Id of the logged user'
      property :token, :string, 'Authorization token for subsequent requests'
    end

    swagger_model :login_body do
      description "A Login request body."
      property :email, :string, :required, 'Email of the user to be logged in'
      property :password, :string, :required, 'Password of the user to be logged in'
    end

    swagger_api :login do
      summary 'Logs in an application user'
      param :body, :body, :login_body, :required, 'Login request body'
      response :ok
      response :unauthorized
      type :login_response
    end

    # POST auths/login
    def login
      if @user
        auth_token = @user.login(params[:password])
        if auth_token
          render json: { user_id: @user.id, token: auth_token }, status: :ok
          return
        end
      else
        @user = User.new
        @user.errors.add(:email, :unregistered)
      end
      render json: @user.errors, status: :unauthorized
    end

    swagger_model :register_response do
      description "The created user."
      property :id, :uuid, 'Id of the created user'
      property :first_name, :string, 'First name of the user user'
      property :last_name, :string, 'Last name of the user'
      property :email, :string, 'Email of the user'
      property :birthday, :date, 'Birthday of the user'
      property :gender, :char, 'Gender of the user'
    end

    swagger_model :register_body do
      description "User parameters to be created."
      property :first_name, :string, :required, 'First name of the user user'
      property :last_name, :string, :required, 'Last name of the user'
      property :email, :string, :required, 'Email of the user'
      property :password, :string, :required, 'Password of the user'
      property :birthday, :date, 'Birthday of the user'
      property :gender, :char, 'Gender of the user'
    end

    swagger_api :register do
      summary 'Registers an application user'
      param :body, :body, :register_body, :required, 'Register request body'
      response :created
      response :bad_request
      response :unauthorized
      response :unprocessable_entity
      type :register_response
    end

    # POST auths/register
    def register
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

      def set_user
        @user = User.find_by_email(params[:email])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :birthday,
            :gender
        )
      end
  end
end
