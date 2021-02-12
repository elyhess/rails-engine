FactoryBot.define do
	factory :item do
		name { Faker::Device.model_name }
		description { Faker::Hacker.say_something_smart }
		unit_price { Faker::Number.decimal(l_digits: 2) }
		merchant
	end
end