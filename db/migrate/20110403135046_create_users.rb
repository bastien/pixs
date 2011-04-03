class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :secret_id
      t.timestamps
    end
    
    add_index :users, :secret_id
  end

  def self.down
    remove_index :users, :secret_id
    drop_table :users
  end
end