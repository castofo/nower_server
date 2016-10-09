module Api::V1
  class AuthsController < ApplicationController
    before_action :set_user, only: [:login]

    # GET auths/index
    # TODO: Remove this, development purposes.
    def index
      render json: User.all
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

    # POST auths/register
    def register
      params[:user] = params[:auth] if params[:user].nil? && !params[:auth].nil?
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
        params.require(:user).permit(
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
