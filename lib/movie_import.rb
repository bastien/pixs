require 'net/http'
require 'json'
require 'open-uri'
require 'nokogiri'

class MovieImport
  class << self
    
    def fetch
      uri = "http://www.deanclatworthy.com/imdb/?q="

      file = File.new(File.join(Rails.root, "cphpix_2011.txt"))
      file.readlines.each do |movie_name|
        movie_name.strip!
        existing_movie = Film.find_by_title(movie_name)
        if movie_name.first == "#" || existing_movie.present?
          # puts "skipping movie #{movie_name}"
        else
          current_uri = uri + movie_name.gsub(/[\s]/, '+')
          data = Net::HTTP.get_response(URI.parse(current_uri)).body
          movie = HashWithIndifferentAccess.new(JSON.parse(data))
          if movie.has_key? :error
            raise "Exceeded API usage limit" if movie[:error] == "Exceeded API usage limit"
            puts movie
            puts "Coudln't find: #{movie_name} puts #{current_uri}"
          else
            if Film.find_by_title(movie[:title]).blank?
              Film.create!(
                :title => movie[:title],
                :imdb_url => movie[:imdburl],
                :imdb_rating => movie[:rating],
                :country => movie[:country],
                :genre => movie[:genres]
                )
            else
              puts "Already in db: #{movie_name} as (#{movie[:title]})"
            end
          end
        end
      end
    end
    
    def fetch_from_youtube
      Film.where(["imdb_url IS NOT NULL AND trailer_url IS NULL"]).each do |film|
        url = "http://www.youtube.com/results?search_category=1&search_type=videos&search_query=#{CGI::escape(film.title + " trailer")}"
        doc = Nokogiri::HTML(open(url))
        result = doc.css(".result-item").first
        if result && result.content.match(/#{film.title}/i)
          trailer_uri = result.css("a").first["href"]
          film.update_attribute :trailer_url, "http://www.youtube.com" + trailer_uri + "&html5=True"
        end
      end
    end
    
    def fetch_from_festival
      urls = [
        "http://www.cphpix.dk/p/tit.lasso",
        "http://www.cphpix.dk/p/tit.lasso?&-skiprecords=50",
        "http://www.cphpix.dk/p/tit.lasso?&-skiprecords=100",
        "http://www.cphpix.dk/p/tit.lasso?&-skiprecords=150",
        "http://www.cphpix.dk/p/tit.lasso?&-skiprecords=200"
      ]
      movies = urls.map do |url|
        scan_page(url)
      end.flatten
      
      movies.each do |movie|
        if film = Film.find_by_title(movie[:title])
          film.update_attributes(:festival_url => movie[:link])
        else
          Film.create(:title => movie[:title], :festival_url => movie[:link])
        end
      end
      
    end
    
    def scan_page(url)
      doc = Nokogiri::HTML(open(url))
      movie_title_elements = doc.css(".movie-list-title")
      movie_title_elements = movie_title_elements.select{|e| !e.content.scan(/[A-Za-z]/).empty? }
      movie_title_elements.map do |movie_title_element|
        title = movie_title_element.content
        puts title
        link = "http://www.cphpix.dk/p/" + movie_title_element.parent["href"]
        puts link
        # thumbnail = movie_box.css(".movie-list-thumbnail img").first["src"]
        # details = movie_box.css(".movie-list-furtherdetail").first.content
        {
          :link => link,
          :title => title
        }
      end
    end
    
  end
end