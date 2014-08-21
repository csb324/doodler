class AddImageColumnToDoodle < ActiveRecord::Migration
  def change
    add_column :doodles, :image, :string
  end
end
