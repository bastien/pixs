class CalendarController < ApplicationController
  def show
    projections = Projection.where(['showtime >= ?', Time.now]).order('showtime')
    @projection_days = projections.group_by do |projection| 
      projection.showtime.to_date
    end
    @bookmarked_films = current_user.present? ? current_user.films.to_a : []
  end
end
