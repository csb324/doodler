class AddWinnersToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :winner_id, :integer
    add_index :missions, :winner_id
  end
end
