class Branch < ApplicationRecord
  belongs_to :store
  has_and_belongs_to_many :promos
  reverse_geocoded_by :latitude, :longitude

  validates :name, presence: true, length: { maximum: 35 }
  validates :latitude, :longitude, :address, presence: true
  validates :default_contact_info, inclusion: { in: [ true, false ] }
end
