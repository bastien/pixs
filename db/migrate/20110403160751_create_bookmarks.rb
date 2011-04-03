class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.integer :user_id
      t.integer :film_id
      t.integer :position
      t.timestamps
    end
    add_index :bookmarks, :user_id
    add_index :bookmarks, :film_id
  end

  def self.down
    remove_index :bookmarks, :film_id
    remove_index :bookmarks, :user_id
    drop_table :bookmarks
  end
end