class Movie < ActiveRecord::Base

	def self.all_ratings
		return Movie.select(:rating).uniq.map(&:rating)
	end	

end
