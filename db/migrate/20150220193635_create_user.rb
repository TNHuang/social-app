class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :first_name, null: false
    	t.string :last_name, null: false
    	t.string :email, null: false
    	t.string :password_digest, null: false
        
        t.integer :posts_count, default: 0
        t.integer :friends_count, default: 0

    	t.timestamps
    end

    add_index :users, [:first_name, :last_name, :email], unique: true
    add_index :users, :email, unique: true
    add_index :users, :first_name
    add_index :users, :last_name
  end
end
