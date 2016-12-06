class Admin < ApplicationRecord
  has_secure_password

  def activated?
    !self.activated_at.nil?
  end

  def generate_confirmation_email_token
    JsonWebToken.encode(action: :confirmation_email, email: self.email)
  end
end
