class AddSubscriptionReferenceAndAmountToPayments < ActiveRecord::Migration[7.0]
  def change
    add_reference :payments, :subscription, index: true, foreign_key: true
    add_column :payments, :amount, :decimal, null: false, default: 0.0
    change_column_null :payments, :token, true
  end
end
