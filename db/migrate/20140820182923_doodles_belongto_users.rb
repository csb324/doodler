class DoodlesBelongtoUsers < ActiveRecord::Migration
  def change
    add_column :doodles, :user_id, :integer
    add_index :doodles, :user_id
  end
end
