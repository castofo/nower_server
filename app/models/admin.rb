class Admin < ApplicationRecord
  before_save :setup_admin_type
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, length: { minimum: 8 }
  validates :admin_type, presence: true
  validates :privileges, numericality: { only_integer: true }
  validate :activated_at_must_not_change_once_set
  validates_datetime :activated_at, allow_nil: true, on_or_before: lambda { DateTime.now }
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

  def activated_at_must_not_change_once_set
    return unless self.activated_at_changed?
    self.errors.add(:activated_at, :changed) unless self.activated_at_change.first.nil?
  end
end
