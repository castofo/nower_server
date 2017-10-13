class OpeningTime < ApplicationRecord
  belongs_to :branch
  validates :day, :opens_at, :closes_at, :valid_from, presence: true
  validates :day, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
  validates_datetime :valid_through, allow_nil: true, on_or_after: :valid_from
end
