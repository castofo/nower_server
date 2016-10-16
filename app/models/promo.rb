class Promo < ApplicationRecord
  validates :name, presence: true, length: { maximum: 140 }
  validates :description, :terms, presence: true
  validate :stock_must_be_greater_than_zero_if_it_was_nil
  validates :price, allow_nil: true, numericality: { greater_than_or_equal_to: 0.0 }
  validate :start_date_cannot_be_modified_if_promo_already_started
  validates_datetime :start_date, :end_date, allow_nil: true, on_or_after: lambda { DateTime.now },
                     if: :dates_changed?
  validates_datetime :start_date, on_or_before: :end_date, if: :should_validate_dates?

  def start_date_cannot_be_modified_if_promo_already_started
    if self.start_date_changed? && !self.start_date_was.nil? && self.start_date_was < DateTime.now
      self.errors.add(:start_date, :already_started)
    end
  end

  def stock_must_be_greater_than_zero_if_it_was_nil
    return unless self.stock_changed?
    if self.stock_change.first.nil? && self.stock_change.second <= 0
      self.errors.add(:stock, :greater_than, count: 0)
    end
  end

  def should_validate_dates?
    return false unless dates_changed?
    any_nil = self.start_date.nil? || self.end_date.nil?
    !any_nil
  end

  def dates_changed?
    self.start_date_changed? || self.end_date_changed?
  end
end
