class AddYearToFilm < ActiveRecord::Migration
  def self.up
    add_column :films, :year, :integer
  end

  def self.down
    remove_column :films, :year
  end
end