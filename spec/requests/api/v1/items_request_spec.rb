require 'rails_helper'

describe "Items API" do
	describe "Items index" do
		it 'sends all items, a maximum of 20 at a time' do
			create_list(:item, 30)

			get '/api/v1/items'

			items = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful

			expect(items[:data].count).to eq(20)
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

		it 'sends an empty array if no data found' do
			get '/api/v1/items'

			items = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful

			expect(items[:data]).to be_an(Array)
			expect(items[:data].size).to eq(0)
		end

		describe "optional query params" do
			describe "per_page" do
				describe "happy path" do
					it 'can fetch set amount of records to display per page' do
						create_list(:item, 20)

						get '/api/v1/items?per_page=10'

						items = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful
						expect(items[:data].size).to eq(10)

						item_ids = items[:data].map { |item| item[:id].to_i }
						expect(item_ids).to eq(Item.ids.first(10))

						get '/api/v1/items?per_page=30'

						items = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful
						expect(items[:data].size).to eq(20)

						item_ids = items[:data].map { |item| item[:id].to_i }
						expect(item_ids).to eq(Item.ids.first(20))
					end
				end
				describe "sad path" do
					it 'fetches per_page 1 if per_page is 0 or lower' do
						create_list(:item, 20)

						get '/api/v1/items?per_page=-1'

						items = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful

						expect(items[:data].size).to eq(1)
						item_ids = items[:data].map { |item| item[:id].to_i }
						expect(item_ids).to eq(Item.ids.first(1))
					end
				end
			end

			describe "page" do
				describe "happy path" do
					it 'can fetch page to display' do
						create_list(:item, 30)

						get '/api/v1/items?page=2'

						items = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful
						expect(items[:data].size).to eq(10)
					end
				end
				describe "sad path" do
					it 'fetches page 1 if page is 0 or lower' do
						create_list(:item, 20)

						get '/api/v1/items?page=-1'

						items = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful

						item_ids = items[:data].map { |item| item[:id].to_i }
						expect(item_ids).to eq(Item.ids.first(20))
						expect(items[:data].size).to eq(20)
					end
				end
			end
		end
	end

	describe "Item show" do
		describe "happy path" do
			it 'can fetch one item by id' do
				id = create(:item).id

				get "/api/v1/items/#{id}"

				expect(response).to be_successful
				item = JSON.parse(response.body, symbolize_names: true)

				expect(item[:data][:id].to_i).to eq(id)
				expect(item[:data]).to have_key(:id)
				expect(item[:data]).to have_key(:type)
				expect(item[:data]).to have_key(:attributes)

				expect(item[:data][:attributes]).to have_key(:name)
				expect(item[:data][:attributes]).to have_key(:description)
				expect(item[:data][:attributes]).to have_key(:unit_price)
				expect(item[:data][:attributes]).to have_key(:merchant_id)
			end
		end
		describe "sad path" do
			it 'bad integer id returns 404' do
				get "/api/v1/items/1"

				expect(response.status).to eq(404)
			end

			it 'string id returns 404' do
				get "/api/v1/items/'1'"

				expect(response.status).to eq(404)
			end
		end
	end

	describe "Item Create" do
		describe "happy path" do
			it 'can create item successfully' do
				merchant = create(:merchant)

				item_params = {name: "My Name",
				               description: "descriptive words",
				               unit_price: 99.99,
				               merchant_id: merchant.id}

				headers = {'CONTENT_TYPE' => 'application/json'}

				post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

				created_item = Item.last

				expect(response).to be_successful
				expect(response.status).to eq(201)

				expect(created_item.name).to eq(item_params[:name])
				expect(created_item.description).to eq(item_params[:description])
				expect(created_item.unit_price).to eq(item_params[:unit_price])
				expect(created_item.merchant_id).to eq(merchant.id)
			end
		end
		describe "sad path" do
			it 'returns error if any attribute(s) missing' do
				merchant = create(:merchant)

				item_params = {name: "My Name",
				               description: "descriptive words",
				               merchant_id: merchant.id}

				headers = {'CONTENT_TYPE' => 'application/json'}
				post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

				expect(response.status).to eq(400)
			end

			it 'ignores attributes sent by the user which are not allowed' do
				merchant = create(:merchant)

				item_params = {name: "My Name",
				               description: "descriptive words",
				               unit_price: 99.99,
				               extra_param: ":)",
				               merchant_id: merchant.id}

				headers = {'CONTENT_TYPE' => 'application/json'}
				post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
				expect(response).to be_successful
				item = Item.last
				
				expect(item).to have_attributes(name: "My Name",
				                                description: "descriptive words",
				                                unit_price: 99.99,
				                                merchant_id: merchant.id)
				expect(item).not_to have_attribute(:extra_param)
			end
		end
	end

	describe "Item Update" do
		describe "happy path" do
			it 'can update an item successfully' do
				old_item = create(:item)
				item_params = {name: "New Name",
				               description: "newdescriptive words",
				               unit_price: 100.01,
				               merchant_id: old_item.merchant_id}
				headers = {"CONTENT_TYPE" => "application/json"}


				patch "/api/v1/items/#{old_item.id}", headers: headers, params: JSON.generate(item: item_params)

				item = Item.find_by(id: old_item.id)
				expect(response).to be_successful
				expect(item.name).to_not eq(old_item.name)
				expect(item.name).to eq(item_params[:name])
			end
			it 'can update partial data on an item successfully' do
				old_item = create(:item)
				item_params = {name: "New Name"}
				headers = {"CONTENT_TYPE" => "application/json"}


				patch "/api/v1/items/#{old_item.id}", headers: headers, params: JSON.generate(item: item_params)

				item = Item.find_by(id: old_item.id)
				expect(response).to be_successful

				expect(item.name).to_not eq(old_item.name)
				expect(item.name).to eq(item_params[:name])

				expect(item.description).to eq(old_item.description)
				expect(item.unit_price).to eq(old_item.unit_price)
				expect(item.merchant_id).to eq(old_item.merchant_id)
			end
		end
		describe "sad path" do
			it 'string id returns 404' do
				patch "/api/v1/items/string_id"

				expect(response.status).to eq(404)
			end
			it 'bad merchant_id returns 404' do
				old_item = create(:item)
				item_params = {name: "New Name",
				               description: "newdescriptive words",
				               unit_price: 100.01,
				               merchant_id: 1023012}
				headers = {"CONTENT_TYPE" => "application/json"}

				patch "/api/v1/items/#{old_item.id}", headers: headers, params: JSON.generate(item: item_params)
				expect(response.status).to eq(400)
			end
			it 'bad integer returns 404' do
				item_params = {name: "New Name",
				               description: "newdescriptive words",
				               unit_price: 100.01,
				               merchant_id: 1023012}
				headers = {"CONTENT_TYPE" => "application/json"}

				patch "/api/v1/items/1231231411231", headers: headers, params: JSON.generate(item: item_params)
				expect(response.status).to eq(404)
			end
		end
	end
	describe "Item Delete" do
		describe "happy path" do
			it 'can delete an item successfully' do
				item = create(:item)

				delete "/api/v1/items/#{item.id}"

				expect(response).to be_successful
				expect(response.status).to eq(204)
				expect(response.body).to be_empty
				expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
			end
			it 'can delete associated invoices only when invoice has no other items' do
				item = create(:item)
				invoice = create(:invoice)
				invoice_item = create(:invoice_item, item: item, invoice: invoice)

				delete "/api/v1/items/#{item.id}"

				expect(response).to be_successful
				expect(Invoice.count).to eq(0)
				expect(InvoiceItem.count).to eq(0)
				expect(Item.count).to eq(0)
			end
		end
		describe "sad path" do
			it 'invalid item id' do
				delete "/api/v1/items/120102319"

				expect(response.status).to eq(404)
			end
		end
	end
end