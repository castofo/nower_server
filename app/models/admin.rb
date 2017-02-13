class Admin < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :password, length: { minimum: 8 }
  validates :admin_type, presence: true
  validate :privileges_array_values
  validate :activated_at_must_not_change_once_set
  validates_datetime :activated_at, allow_nil: true, on_or_before: lambda { DateTime.now }
  after_create :send_verification_email
  has_secure_password

  def initialize(attrs = {})
    attrs[:admin_type] = :branch_admin
    super(attrs)
  end

  def activated?
    !self.activated_at.nil?
  end

  # Tries to login the current admin with the given password. Adds an error if the password
  # is invalid.
  # @return [String] the authorization token if the password is correct, nil otherwise.
  def login(password)
    return JsonWebToken.encode(admin_id: self.id) if self.authenticate(password)
    self.errors.add(:password, :invalid)
    nil
  end

  def send_verification_email
    AdminMailer.password_confirmation(self).deliver_later
  end

  def generate_confirmation_email_token
    JsonWebToken.encode(action: :confirmation_email, email: self.email)
  end

  def privileges_array_values
    return self.errors.add(:privileges, :not_array) unless self.privileges.is_a?(Array)
    self.privileges.each do |privilege|
      if Constants::Admin::PRIVILEGES[privilege].nil?
        self.errors.add(:privileges, :invalid, privilege: privilege)
      end
    end
  end

  def activated_at_must_not_change_once_set
    return unless self.activated_at_changed?
    self.errors.add(:activated_at, :changed) unless self.activated_at_change.first.nil?
  end
end
