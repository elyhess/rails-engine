FactoryBot.define do
	factory :transaction do
		credit_card_number { Faker::Business.credit_card_number }
		credit_card_expiration_date { "2020-08-29" }
		result { "success" }
		invoice
	end
end