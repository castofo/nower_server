class Promo < ApplicationRecord
  has_and_belongs_to_many :branches

  validates :name, presence: true, length: { maximum: 140 }
  validates :description, :terms, presence: true
  validate :stock_or_end_date_present
  validate :stock_must_be_greater_than_zero_if_it_was_nil
  validates :price, allow_nil: true, numericality: { greater_than_or_equal_to: 0.0 }
  validate :start_date_cannot_be_modified_if_promo_already_started
  validate :start_date_present_if_end_date_is_present
  validates_datetime :start_date, :end_date, allow_nil: true, on_or_after: lambda { DateTime.now },
                     if: :dates_changed?
  validates_datetime :start_date, on_or_before: :end_date, if: :should_validate_dates?

  # Scopes promos to be only those which have stock and haven't expired (CAN INCLUDE NON-STARTED)
  scope :available, -> {
      where('CASE WHEN stock IS NOT ? AND end_date IS NOT ? THEN
                 CASE WHEN stock > 0 AND end_date > ? THEN true
                 ELSE false
                 END
             WHEN stock IS NOT ? AND stock > 0 THEN true
             WHEN end_date IS NOT ? AND end_date > ? THEN true
             ELSE false
             END',
           nil, nil, DateTime.now, nil, nil, DateTime.now)
  }

  # Scopes promos to those which already started (CAN INCLUDE ALREADY ENDED)
  scope :started, -> { where('start_date <= ? OR start_date IS ?', DateTime.now, nil) }

  def stock_or_end_date_present
    self.errors.add(:base, :missing_expiring_condition) if self.stock.nil? && self.end_date.nil?
  end

  def start_date_cannot_be_modified_if_promo_already_started
    if self.start_date_changed? && !self.start_date_was.nil? && self.start_date_was < DateTime.now
      self.errors.add(:start_date, :already_started)
    end
  end

  def start_date_present_if_end_date_is_present
    if !self.end_date.nil? && self.start_date.nil?
      self.errors.add(:end_date, :without_start_date)
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
