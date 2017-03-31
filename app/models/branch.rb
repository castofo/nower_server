class Branch < ApplicationRecord
  has_and_belongs_to_many :promos
end
