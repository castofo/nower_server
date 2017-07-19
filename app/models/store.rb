class Store < ApplicationRecord
  has_many :branches
  has_many :contact_informations

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, :nit, presence: true
  validate :statuses_inclusion

  def statuses_inclusion
    unless !self.status.nil? && Constants::Store::STATUSES.include?(self.status.to_sym)
      self.errors.add(:status, :invalid, status: self.status)
    end
  end
end
