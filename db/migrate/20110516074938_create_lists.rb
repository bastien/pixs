class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.string  :name
      t.integer :user_id
      t.timestamps
    end
    add_column :films, :list_id, :integer
    
    add_index :lists, :name
    add_index :films, :list_id
  end

  def self.down
    remove_index :films, :list_id
    remove_column :films, :list_id
    remove_index :lists, :name
    drop_table :lists
  end
end