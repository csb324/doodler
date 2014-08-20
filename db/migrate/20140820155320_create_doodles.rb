class CreateDoodles < ActiveRecord::Migration
  def change
    create_table :doodles do |t|
      t.string :name
      t.references :mission
    end
  end
end
