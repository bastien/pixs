require 'open-uri'
require 'nokogiri'

class Film < ActiveRecord::Base
  attr_accessor :skip_imdb_url
  
  after_save :get_imdb_data
  
  def get_imdb_data
    if !@skip_imdb_url && imdb_url_changed? && imdb_url.present?
      puts "[imdb_url] changed"
      update_imdb_data
    end
  end
  
  def imdb_id
    return nil unless imdb_url?
    imdb_url.gsub("http://www.imdb.com/title/", "").gsub("/", "")
  end
  
  def youtube_id
    trailer_url.match(/http:\/\/www.youtube.com\/watch\?v=([a-zA-Z0-9\-\_]*)\??/).to_a.last
  end

  def update_imdb_data
    @skip_imdb_url = true
    if imdb_id.nil?
      puts "imdb_id nil for #{title}"
      return false
    end
    movie_hash = MovieImport.by_imdb_id(imdb_id)
    if movie_hash.nil?
      puts "couldn't find #{imdb_id} (#{title})"
      return false
    end
    values = {
      :genre        => movie_hash[:Genre],
      :synopsis     => movie_hash[:Plot],
      :director     => movie_hash[:Director],
      :writer       => movie_hash[:Writer],
      :thumbnail_url => movie_hash[:Poster]
    }
    rating = direct_imdb_rating
    values[:imdb_rating] = rating if rating.present? # movie_hash[:Rating].to_f, # inacurate
    update_attributes(values)
  end
  
  # Not using the API for this one because not accurate
  #
  def direct_imdb_rating
    return nil if imdb_url.nil?
    doc = Nokogiri::HTML(open(imdb_url))
    rating = doc.css(".rating-rating").first.content.split("/").first.to_f
  end
  
  def init_imdb_data
    @skip_imdb_url = true
    movie_hash = MovieImport.by_imdb_title(title)
    return false if movie_hash.nil?
    update_attributes(
      :imdb_url     => "http://www.imdb.com/title/"+movie_hash[:ID]+"/",
      :imdb_rating  => movie_hash[:Rating].to_f,
      :country      => movie_hash[:Country],
      :genre        => movie_hash[:Genre],
      :synopsis     => movie_hash[:Plot],
      :director     => movie_hash[:Director],
      :writer       => movie_hash[:Writer],
      :thumbnail_url => movie_hash[:Poster]
    )
  end
  
  class << self
    def fetch_imdb_data
      # where(["imdb_url IS NULL"]).each do |film|
      #  puts "Initializing : #{film.title}"
      #  film.init_imdb_data
      # end
      where(["imdb_url IS NOT NULL AND (genre IS NULL OR director is NULL OR synopsis IS NULL)"]).each do |film|
        puts "Upating : #{film.title}"
        film.update_imdb_data
      end
    end
  end
end
