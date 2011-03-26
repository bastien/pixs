namespace :maintenance do
  desc "Updates IMDB Data on all movies"
  task :update_imdb => :environment do
    Film.all.map(&:update_imdb_data)
  end
  
  desc "Updates IMDB Data on all movies"
  task :retrieve_dates => :environment do
    Film.where(:year => nil).where(["festival_url IS NOT NULL"]).each do |film|
      MovieImport.get_year_from_festival(film)
    end
  end
end