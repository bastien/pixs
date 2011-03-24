namespace :maintenance do
  desc "Updates IMDB Data on all movies"
  task :update_imdb => :environment do
    Film.all.map(&:update_imdb_data)
  end
end