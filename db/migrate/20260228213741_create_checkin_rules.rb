class CreateCheckinRules < ActiveRecord::Migration[8.1]
  def change
    create_table :checkin_rules do |t|
      t.string :name
      t.boolean :is_mandatory, default: false
      t.boolean :is_active, default: true
      t.integer :start_minutes
      t.integer :end_minutes
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end