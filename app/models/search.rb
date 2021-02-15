class Search < ApplicationRecord

	def self.find_one(collection, name)
		collection.where('LOWER(name) LIKE ?', "%#{name.downcase}%")
		          .order(:name)
		          .first
	end

end