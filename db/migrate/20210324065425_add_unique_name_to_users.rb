class AddUniqueNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unique_name, :string, unique: true
    add_index  :users, :unique_name, unique: true
  end
end
