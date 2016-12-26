class Admin < ApplicationRecord
  before_save :setup_admin_type
  has_secure_password

  def activated?
    !self.activated_at.nil?
  end

  def generate_confirmation_email_token
    JsonWebToken.encode(action: :confirmation_email, email: self.email)
  end

  # Tries to login the current admin with the given password. Adds an error if the password
  # is invalid.
  # @return [String] the authorization token if the password is correct, nil otherwise.
  def login(password)
    return JsonWebToken.encode(admin_id: self.id) if self.authenticate(password)
    self.errors.add(:password, :invalid)
    nil
  end

  def setup_admin_type
    self.admin_type = :branch_admin
  end
end
