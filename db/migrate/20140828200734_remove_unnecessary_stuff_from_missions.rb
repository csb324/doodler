class RemoveUnnecessaryStuffFromMissions < ActiveRecord::Migration
  def up
    change_table :missions do |t|
      t.remove :user_id, :description
    end

    add_index :missions, :created_at
  end

  def down
    change_table :missions do |t|
      t.references :user
      t.string :description
    end
    remove_index :missions, :created_at
  end

end
