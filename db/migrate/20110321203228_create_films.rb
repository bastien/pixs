class CreateFilms < ActiveRecord::Migration
  def self.up
    create_table :films do |t|
      t.string :title
      t.boolean :favorite
      t.string :thumbnail_url
      t.string :imdb_url
      t.float :imdb_rating
      t.string :country
      t.string :genre
      t.text  :synopsis
      t.string :trailer_url
      t.timestamps
    end
  end

  def self.down
    drop_table :films
  end
end
