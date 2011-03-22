class AddFestivalUrlToFilms < ActiveRecord::Migration
  def self.up
    add_column :films, :festival_url, :string
  end

  def self.down
    remove_column :films, :festival_url
  end
end