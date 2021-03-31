class AddLikesCountToMicroposts < ActiveRecord::Migration[5.1]
  def self.up
    add_column :microposts, :likes_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :microposts, :likes_count
  end
end
