class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :plan, foreign_key: true, index: true, null: false
      t.references :customer, foreign_key: true, index: true, null: false
      t.datetime :expires_at, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :subscriptions, %i[plan_id customer_id], unique: true
  end
end
