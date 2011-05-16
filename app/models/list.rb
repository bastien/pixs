class List < ActiveRecord::Base
  has_many :films
  has_many :projections, :through => :films
  belongs_to :user
  
  attr_accessor :file
  
  after_create :parse_file
  
  protected
  
  def parse_file
    return false if @file.nil?
    case File.extname(@file.path)
    when '.json' then parse_json(@file.read)
    when '.csv'  then parse_csv(@file.path)
    else
      raise "Format not supported '#{File.extname(@file.path)}'"
    end
  end
  
  def parse_json(json)
    film_list = HashWithIndifferentAccess.new(JSON.parse(json))
    film_list[:films].each do |film|
      films.create(film)
    end
  end
  
  def parse_csv(csv_file)
    FasterCSV.read(csv_file, :headers => :first_row).each do |film_row|
      films.create(film_row.to_hash)
    end
  end
end
