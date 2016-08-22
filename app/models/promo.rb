class Promo < ApplicationRecord
  validates :name, presence: true, length: { maximum: 140 }
  validates :description, :terms, presence: true
  validate :stock_must_be_greater_than_zero_if_it_was_nil
  validates :price, allow_nil: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates_datetime :start_date, :end_date, allow_nil: true, on_or_after: lambda { DateTime.now }
  validates_datetime :start_date, on_or_before: :end_date, if: :should_validate_dates?

  def stock_must_be_greater_than_zero_if_it_was_nil
    return unless self.stock_changed?
    if self.stock_change.first.nil? && self.stock_change.second <= 0
      errors.add(:stock, :greater_than, count: 0)
    end
  end

  def should_validate_dates?
    return false unless self.start_date_changed? || self.end_date_changed?
    any_nil = self.start_date.nil? || self.end_date.nil?
    return !any_nil
  end
end
