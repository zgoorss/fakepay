class ChangePriceInPlans < ActiveRecord::Migration[7.0]
  def change
    rename_column :plans, :price, :price_in_cents
  end
end
