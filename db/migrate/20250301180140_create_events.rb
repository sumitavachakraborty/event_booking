class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :venue
      t.datetime :event_date
      t.references :event_organizer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
