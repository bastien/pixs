class AddDirectorToFilms < ActiveRecord::Migration
  def self.up
    add_column :films, :director, :string
    add_column :films, :writer, :string
  end

  def self.down
    remove_column :films, :writer
    remove_column :films, :director
  end
end