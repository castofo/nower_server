module Api::V1
  class AuthsController < ApplicationController
    before_action :set_user, only: [:login]

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

    private

      def set_user
        @user = User.find_by_email(params[:email])
      end
  end
end
