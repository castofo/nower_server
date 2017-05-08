class Branch < ApplicationRecord
  has_and_belongs_to_many :promos
  reverse_geocoded_by :latitude, :longitude
end
