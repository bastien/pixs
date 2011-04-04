class CreateProjections < ActiveRecord::Migration
  def self.up
    create_table :projections do |t|
      t.datetime :showtime
      t.string :venue
      t.integer :film_id

      t.timestamps
    end
    add_index :projections, :film_id
    add_index :projections, :showtime
  end

  def self.down
    remove_index :projections, :film_id
    remove_index :projections, :showtime
    drop_table :projections
  end
end