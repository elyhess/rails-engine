class Search < ApplicationRecord

	def self.find_all_name(collection, name)
		collection.where('LOWER(name) LIKE ?', "%#{name.downcase}%")
		          .order(:name)
	end

	def self.find_all_price(collection, min, max)
		min_price = min || 0
		max_price = max || Float::INFINITY
		collection.where('unit_price BETWEEN ? AND ?', min_price, max_price)
		          .order(:unit_price)
	end

end