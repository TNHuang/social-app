class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
    	t.integer :left_friend_id, null: false
    	t.integer :right_friend_id, null: false
    	t.integer :status, default: 1

    	t.timestamps
    end
    add_index :friendships, [:left_friend_id, :right_friend_id], unique: true
    add_index :friendships, :left_friend_id
    add_index :friendships, :right_friend_id
  end
end
