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
end
