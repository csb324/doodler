class MakeDoodlesPolymorphic < ActiveRecord::Migration
  def up
    change_table :doodles do |t|
      t.remove :name
      t.remove :image_path
      t.remove :mission_id

      t.references :doodleable, polymorphic: true, index: true
    end
  end

  def down
    change_table :doodles do |t|
      t.string :name
      t.string :image_path
      t.integer :mission_id

      t.remove :doodleable_id
      t.remove :doodleable_type
    end
  end
end
