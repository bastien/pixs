class Projection < ActiveRecord::Base
  belongs_to :film
  validates_uniqueness_of :showtime, :scope => :film_id
end
