class User < ApplicationRecord
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
