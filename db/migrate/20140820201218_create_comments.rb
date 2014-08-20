class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.timestamps
      t.references :user, null: false
      t.references :doodle, null: false
      t.string :body
    end
  end
end
