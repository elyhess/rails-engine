require 'rails_helper'

describe "Items API" do
	describe 'Item Name Search' do
		describe "happy path" do
			it 'returns all items matching a search term' do
				item = create_list(:item, 4)
				item1 = create(:item, name: "hello world item")
				item2 = create(:item, name: "heavenly item")
				item3 = create(:item, name: "heavy cream item")

				get "/api/v1/items/find_all?name=he"

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)
				expect(items[:data].count).to eq(3)

				expect(items[:data][0]).to have_key(:id)
				expect(items[:data][0]).to have_key(:type)
				expect(items[:data][0]).to have_key(:attributes)

				items[:data].each do |item|
					expect(item).to be_a(Hash)
					expect(item[:attributes]).to have_key(:name)
					expect(item[:attributes][:name]).to be_a(String)
					expect(item[:attributes]).to have_key(:description)
					expect(item[:attributes][:description]).to be_a(String)
					expect(item[:attributes]).to have_key(:unit_price)
					expect(item[:attributes][:unit_price]).to be_a(Float)
					expect(item[:attributes]).to have_key(:merchant_id)
					expect(item[:attributes][:merchant_id]).to be_a(Integer)
				end
			end
			it 'returns all items if no query param introduces' do
				item = create_list(:item, 4)

				get "/api/v1/items/find_all"

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)

				expect(items[:data].count).to eq(4)
			end
		end
		describe "sad path" do
			it 'no fragment matched' do
				get "/api/v1/items/find_all?name=randomname"

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)

				expect(items[:data]).to be_an(Array)
				expect(items[:data].size).to eq(0)
			end
			it 'no fragment given' do
				get "/api/v1/items/find_all?name="

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)

				expect(items[:data]).to be_an(Array)
				expect(items[:data].size).to eq(0)
			end
		end
	end

	describe "Item Price Search" do
		describe "happy path" do
			it 'returns min price query' do
				item1 = create(:item, unit_price: 3.99)
				item2 = create(:item, unit_price: 12.99)
				item3 = create(:item, unit_price: 5.99)

				get "/api/v1/items/find_all?min_price=4.00"

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)
				expect(items[:data].count).to eq(2)

				item_ids = items[:data].map { |item| item[:id].to_i }
				expect(item_ids).to include(item2.id, item3.id)
				expect(item_ids).to_not include(item1.id)
			end
			it 'returns max price query' do
				item1 = create(:item, unit_price: 3.99)
				item2 = create(:item, unit_price: 12.99)
				item3 = create(:item, unit_price: 5.99)

				get "/api/v1/items/find_all?max_price=4.00"

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)
				expect(items[:data].count).to eq(1)

				item_ids = items[:data].map { |item| item[:id].to_i }
				expect(item_ids).to include(item1.id)
				expect(item_ids).to_not include(item2.id, item3.id)
			end
			it 'returns both min and max price query' do
				item1 = create(:item, unit_price: 3.99)
				item2 = create(:item, unit_price: 12.99)
				item3 = create(:item, unit_price: 5.99)
				item4 = create(:item, unit_price: 19.99)

				get "/api/v1/items/find_all?min_price=5.00&max_price=18.00"

				expect(response).to be_successful
				items = JSON.parse(response.body, symbolize_names: true)
				expect(items[:data].count).to eq(2)

				item_ids = items[:data].map { |item| item[:id].to_i }
				expect(item_ids).to include(item2.id, item3.id)
				expect(item_ids).to_not include(item1.id, item4.id)
			end
		end
		describe "sad path" do
			it 'doest allow for price query AND name query' do
				create_list(:item, 5)
				get "/api/v1/items/find_all?name=string&min_price=5.00&max_price=18.00"

				expect(response.status).to eq(404)
			end
		end
	end
end
