class RemoveCustomerReferenceFromPayments < ActiveRecord::Migration[7.0]
  def change
    remove_reference :payments, :customer, index: true, foreign_key: true
  end
end
