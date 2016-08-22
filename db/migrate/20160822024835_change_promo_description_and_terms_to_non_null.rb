class ChangePromoDescriptionAndTermsToNonNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :promos, :description, false
    change_column_null :promos, :terms, false
  end
end
