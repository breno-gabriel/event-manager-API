class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email
      t.boolean :check_in_status, default: false
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
