class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies do |t|
      t.integer :destination_id
      t.integer :reply_micropost_id

      t.timestamps
    end
    add_index :replies, :destination_id
    add_index :replies, :reply_micropost_id
    add_index :replies, [:destination_id , :reply_micropost_id]
  end
end
