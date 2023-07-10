class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.integer :tin
      t.string :email

      t.timestamps
    end
  end
end
