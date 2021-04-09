class AddColumnsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :addressee_user_id, :integer
    add_column :messages, :read, :boolean, default: false
    add_index :messages, :addressee_user_id
    add_index :messages, [:addressee_user_id, :read]
  end
end
