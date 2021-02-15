require 'rails_helper'

describe "Merchants API" do
	describe 'Merchant Search' do
		describe "happy path" do
			it 'finds a single item matching a search term' do
				merchant_1 = create(:merchant)
				merchant_2 = create(:merchant)
				merchant_3 = create(:merchant)

				get "/api/v1/merchants/find?name=#{merchant_1.name}"

				expect(response).to be_successful
				merchant = JSON.parse(response.body, symbolize_names: true)

				expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
				expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
			end
		end
		describe "sad path" do
			it 'no fragment matched' do
				merchant_1 = create(:merchant)
				merchant_2 = create(:merchant)
				merchant_3 = create(:merchant)

				get "/api/v1/merchants/find?name=5"
				expect(response).to be_successful
				merchant = JSON.parse(response.body, symbolize_names: true)

				expect(merchant).to have_key(:data)
				expect(merchant[:data]).to be_a(Hash)
				expect(merchant[:data]).to be_empty
			end
			it 'no fragment given' do
				merchant_1 = create(:merchant)
				merchant_2 = create(:merchant)
				merchant_3 = create(:merchant)

				get "/api/v1/merchants/find"

				expect(response).to be_successful

				merchant = JSON.parse(response.body, symbolize_names: true)

				expect(merchant).to have_key(:data)
				expect(merchant[:data]).to be_a(Hash)
				expect(merchant[:data]).to be_empty
			end
		end
	end
end
