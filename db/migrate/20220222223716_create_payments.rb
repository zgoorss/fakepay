class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :customer, foreign_key: true, index: true, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
