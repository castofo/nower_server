class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :gender, length: { is: 1 }, inclusion: { in: %w(M F) }, allow_nil: true
  has_secure_password

  # Tries to login the current user with the given password. Adds an error if the password
  # is invalid.
  # @return [String] the authorization token if the password is correct, nil otherwise.
  def login(password)
    return JsonWebToken.encode(user_id: self.id) if self.authenticate(password)
    self.errors.add(:password, :invalid)
    nil
  end
end
