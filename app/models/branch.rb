class Branch < ApplicationRecord
  belongs_to :store
  has_and_belongs_to_many :promos
  has_and_belongs_to_many :contact_informations
  has_many :opening_times
  reverse_geocoded_by :latitude, :longitude

  validates :name, presence: true, length: { maximum: 35 }
  validates :latitude, :longitude, :address, presence: true
  validates :default_contact_info, inclusion: { in: [ true, false ] }

  scope :geolocated, -> (latitude, longitude) do
    near([latitude, longitude], Constants::Branch::DEFAULT_BRANCH_NEARNESS_KM, units: :km)
  end
  scope :store_id, -> (store_id) { where store_id: store_id }
end
