class Movie < ActiveRecord::Base
	#used to select the movie ratings [G, R, PG-13, PG]
	def self.all_ratings
		return Movie.select(:rating).uniq.map(&:rating)
	end	

end
