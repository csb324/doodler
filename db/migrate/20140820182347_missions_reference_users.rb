class MissionsReferenceUsers < ActiveRecord::Migration
  def change
    add_column :missions, :user_id, :integer
    add_index :missions, :user_id
  end
end
