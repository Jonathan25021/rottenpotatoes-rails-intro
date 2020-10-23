class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list == nil or ratings_list == []
      return self.with_ratings(self.all_ratings)
    else 
      return self.where(rating: ratings_list)
    end
  end
  
  def self.all_ratings
    return ['G','PG','PG-13','R','NC-17']
  end
  
  def self.sort_by_title(ratings_list)
    return self.with_ratings(ratings_list).order(:title)
  end
  
  def self.sort_by_release_date(ratings_list)
    return self.with_ratings(ratings_list).order(:release_date)
  end
end
