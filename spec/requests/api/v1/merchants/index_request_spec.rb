require 'rails_helper'

describe "Merchants API" do
	describe 'Merchant Items Index' do
		it 'can get a merchants items' do
			merchant = create(:merchant)
			5.times do
				create(:item, merchant: merchant)
			end

			get "/api/v1/merchants/#{merchant.id}/items"

			expect(response).to be_successful
			items = JSON.parse(response.body, symbolize_names: true)

			item_ids = items[:data].map { |item| item[:id].to_i }

			expect(items[:data].size).to eq(5)
			expect(items[:data][0]).to have_key(:id)
			expect(items[:data][0]).to have_key(:type)
			expect(items[:data][0]).to have_key(:attributes)
			expect(item_ids).to eq(Item.ids.first(5))
		end

		it 'must have valid merchant id' do
			get "/api/v1/merchants/145141223/items"

			expect(response.status).to eq(404)
		end
	end
end
