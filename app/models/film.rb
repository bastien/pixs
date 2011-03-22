require 'open-uri'
require 'nokogiri'

class Film < ActiveRecord::Base
  attr_accessible :imdb_url
  attr_accessible :skip_imdb_url
  
  after_save :get_imdb_data
  
  def get_imdb_data
    if imdb_url_changed? && !@skip_imdb_url
      puts "[imdb_url] changed"
      update_imdb_data
    end
  end

  def update_imdb_data
    doc = Nokogiri::HTML(open(imdb_url))
    rating = doc.css(".rating-rating").first.content.split("/").first.to_f
    puts "rating : #{rating}"
    @skip_imdb_url = true
    update_attribute(:imdb_rating, rating)
  end
end
