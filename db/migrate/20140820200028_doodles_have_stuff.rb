class DoodlesHaveStuff < ActiveRecord::Migration
  def change
    change_table :doodles do |t|
      t.string :image_path, default: "bunny.jpg"
    end
  end
end
