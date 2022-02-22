class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :zip_code, null: false

      t.timestamps
    end

    add_index :customers, %i[name address zip_code], unique: true
  end
end
