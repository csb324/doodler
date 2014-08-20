class MissionsHaveDescriptions < ActiveRecord::Migration
  def change
    add_column :missions, :description, :string
  end
end
