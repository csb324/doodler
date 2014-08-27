class AddTimestampsToDoodles < ActiveRecord::Migration
  def change
    change_table :doodles do |t|
      t.timestamps
    end
  end
end
