class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true

      t.timestamps
    end
    add_index :likes, [:user_id, :micropost_id], unique: true
  end
end
