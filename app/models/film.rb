require 'open-uri'
require 'nokogiri'

class Film < ActiveRecord::Base
  attr_accessor :skip_imdb_url
  
  belongs_to :list
  has_many :projections, :dependent => :destroy
  
  accepts_nested_attributes_for :projections
  
  after_create :init_imdb_data
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
    imdb = ImdbParty::Imdb.new
    movie = imdb.find_movie_by_id(imdb_id)
    update_imdb_attributes(movie)
  end
  
  def init_imdb_data
    if imdb_url.blank?
      @skip_imdb_url = true
      imdb = ImdbParty::Imdb.new
      results = imdb.find_by_title(title)
      return false if results.empty?
      result = results.find{|r| r[:year].to_s == year.to_s } if year.present?
      result ||= results.first
      movie = imdb.find_movie_by_id(result[:imdb_id])
      update_imdb_attributes(movie)
    end
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
  
  protected
  
  def update_imdb_attributes(movie)
    update_attributes(
      :imdb_url     => "http://www.imdb.com/title/"+movie.imdb_id+"/",
      :imdb_rating  => (movie.rating || 0.0),
      #:country      => movie_hash[:Country],
      :genre        => movie.genres.join(', '),
      :synopsis     => movie.plot,
      :director     => movie.directors.map(&:name).join(", "),
      :writer       => movie.writers.map(&:name).join(", "),
      :thumbnail_url => movie.poster_url
    )
  end
  
end
