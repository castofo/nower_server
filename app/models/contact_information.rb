class ContactInformation < ApplicationRecord
  belongs_to :store
  has_and_belongs_to_many :branches
  validates :key, :value, presence: true
  # For the given key, it should be unique in the scope of store_id
  validates :key, uniqueness: { scope: :store_id }

  scope :store_id, -> (store_id) { where store_id: store_id }
  scope :branch_id, -> (branch_id) { joins(:branches).where(branches: { id: branch_id }) }
end
