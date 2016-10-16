class ApplicationController < ActionController::API

  def authenticate!
    @error = nil
    @current_user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    unless @current_user
      @error = I18n.t :invalid_token, scope: [:errors, :authorization] unless @error
      render json: { error: @error }, status: :unauthorized
    end
  end

  private

    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    end

    def http_auth_header
      if request.headers['Authorization'].present?
        return request.headers['Authorization'].split(' ').last
      else
        @error = I18n.t :missing_header, scope: [:errors, :authorization]
      end
      nil
    end
end
