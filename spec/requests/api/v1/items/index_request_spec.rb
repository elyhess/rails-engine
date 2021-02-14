require 'rails_helper'

describe 'Item Merchant Index' do
	it 'can get an items merchant' do
		item = create(:item)
		get "/api/v1/items/#{item.id}/merchant"

		expect(response).to be_successful
		merchant = JSON.parse(response.body, symbolize_names: true)

		expect(merchant[:data][:id].to_i).to eq(item.merchant_id)
	end

	it 'must have valid item id' do
		get "/api/v1/items/51441241/merchant"

		expect(response.status).to eq(404)
	end
end