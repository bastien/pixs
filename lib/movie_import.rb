require 'net/http'
require 'json'
require 'open-uri'
require 'nokogiri'

class MovieImport
  class << self
    def fetch_from_youtube
      Film.where(["imdb_url IS NOT NULL AND trailer_url IS NULL"]).each do |film|
        url = "http://www.youtube.com/results?search_category=1&search_type=videos&search_query=#{CGI::escape(film.title + " trailer")}"
        doc = Nokogiri::HTML(open(url))
        result = doc.css(".result-item").first
        result_alternative = doc.css(".result-item")[1]
        if result && result.content.match(/#{film.title}/i)
          trailer_uri = result.css("a").first["href"]
          film.update_attribute :trailer_url, "http://www.youtube.com" + trailer_uri + "&html5=True"
        elsif result_alternative && result_alternative.content.match(/#{film.title}/i)
          trailer_uri = result_alternative.css("a").first["href"]
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
          film = Film.create(:title => movie[:title], :festival_url => movie[:link])
        end
        get_year_from_festival(film)
      end
    end
    
    def get_year_from_festival(film)
      doc = Nokogiri::HTML(open(film.festival_url))
      info = doc.css(".header .text p").first.content
      match_data = info.match(/\s\d{4}\s/)
      if match_data.present?
        year = match_data[-1].strip.to_i
        film.update_attribute(:year, year)
      end
    end
    
    def get_display_times_from_festival(film)
      doc = Nokogiri::HTML(open(film.festival_url))
      info = doc.css("ul.viewings li span.details").each do |showtime|
        details = showtime.content.split(" | ")
        date_time = DateTime.strptime(details[0..1].join(" "), '%d/%m %H:%M')
        venue = details[3]
        film.projections.create(:venue => venue, :showtime => date_time)
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
    
    # Small script to test the efficiency of IMDB-Party gem
    #
    def test_imdb_party
      correct = partial = wrong = 0
      Film.where(["imdb_url IS NOT NULL"]).each do |film|
        imdb = ImdbParty::Imdb.new
        results = imdb.find_by_title(film.title)
        if results.empty?
          puts "Couldn't find: #{film.title}"
        else
          result = results.find{|r| r[:year].to_s == film.year.to_s } if film.year.present?
          result ||= results.first
          if result[:imdb_id] != film.imdb_id
            puts "Diff #{ film.title }: -#{film.imdb_id} +#{result[:imdb_id]}"
            puts "#{imdb.find_movie_by_id(result[:imdb_id]).title}"
            wrong += 1
          else
            correct +=1
          end
        end
        movie = imdb.find_movie_by_id(film.imdb_id)
        if movie.blank?
          puts "Couldn't find #{film.imdb_id}"
        end
      end
      puts "Stats: correct:#{correct} partial:#{partial} wrong:#{wrong}"
    end
  end
end