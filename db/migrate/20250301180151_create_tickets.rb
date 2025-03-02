class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :name
      t.decimal :price
      t.integer :quantity_available
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
