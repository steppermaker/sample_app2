class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
    add_index :entries, :user_id
    add_index :entries, :room_id
    add_index :entries, [:user_id, :room_id], unique: true
  end
end
