module FilmsHelper

  def rating_color(rating)
    return "" if rating.nil? || rating == 0.0
    case rating
    when 7..10
      "green"
    when 5..7
      "yellow"
    else
      "red"
    end
  end

end
