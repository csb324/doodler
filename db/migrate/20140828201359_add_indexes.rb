class AddIndexes < ActiveRecord::Migration
  def change

    add_index :comments, :user_id
    add_index :comments, :doodle_id

    add_index :doodles, :created_at

    add_index :friendships, :user_id
    add_index :friendships, :friend_id

  end
end
