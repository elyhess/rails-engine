require 'rails_helper'

describe "Merchants API" do
	describe "Merchants Index" do
		it 'sends all merchants, a maximum of 20 at a time' do
			create_list(:merchant, 30)

			get '/api/v1/merchants'

			merchants = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful

			expect(merchants[:data].count).to eq(20)
			expect(merchants[:data][0]).to have_key(:id)
			expect(merchants[:data][0]).to have_key(:type)
			expect(merchants[:data][0]).to have_key(:attributes)

			merchants[:data].each do |merchant|
				expect(merchant).to be_a(Hash)
				expect(merchant[:attributes]).to have_key(:name)
				expect(merchant[:attributes][:name]).to be_a(String)
			end
		end
		it 'sends an empty array if no data found' do
			get '/api/v1/merchants'

			merchants = JSON.parse(response.body, symbolize_names: true)

			expect(response).to be_successful

			expect(merchants[:data]).to be_an(Array)
			expect(merchants[:data].size).to eq(0)
		end
		describe "optional query params" do
			describe "per_page" do
				describe "happy path" do
					it 'can fetch set amount of records to display per page' do
						create_list(:merchant, 20)

						get '/api/v1/merchants?per_page=10'

						merchants = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful
						expect(merchants[:data].size).to eq(10)

						merchant_ids = merchants[:data].map { |merchant| merchant[:id].to_i }
						expect(merchant_ids).to eq(Merchant.ids.first(10))

						get '/api/v1/merchants?per_page=30'

						merchants = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful
						expect(merchants[:data].size).to eq(20)

						merchant_ids = merchants[:data].map { |merchant| merchant[:id].to_i }
						expect(merchant_ids).to eq(Merchant.ids.first(20))
					end
				end
				describe "sad path" do
					it 'fetches per_page 1 if per_page is 0 or lower' do
						create_list(:merchant, 20)

						get '/api/v1/merchants?per_page=-1'

						merchants = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful

						expect(merchants[:data].size).to eq(1)
						merchant_ids = merchants[:data].map { |merchant| merchant[:id].to_i }
						expect(merchant_ids).to eq(Merchant.ids.first(1))
					end
				end
			end

			describe "page" do
				describe "happy path" do
					it 'can fetch page to display' do
						create_list(:merchant, 30)

						get '/api/v1/merchants?page=2'

						merchants = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful
						expect(merchants[:data].size).to eq(10)
					end
				end
				describe "sad path" do
					it 'fetches page 1 if page is 0 or lower' do
						create_list(:merchant, 20)

						get '/api/v1/merchants?page=-1'

						merchants = JSON.parse(response.body, symbolize_names: true)
						expect(response).to be_successful

						merchant_ids = merchants[:data].map { |merchant| merchant[:id].to_i }
						expect(merchant_ids).to eq(Merchant.ids.first(20))
						expect(merchants[:data].size).to eq(20)
					end
				end
			end
		end
	end
	describe "Merchant Show" do
		describe "happy path" do
			it 'can fetch one item by id' do
				id = create(:merchant).id

				get "/api/v1/merchants/#{id}"

				expect(response).to be_successful
				merchant = JSON.parse(response.body, symbolize_names: true)

				expect(merchant[:data][:id].to_i).to eq(id)
				expect(merchant[:data]).to have_key(:id)
				expect(merchant[:data]).to have_key(:type)
				expect(merchant[:data]).to have_key(:attributes)

				expect(merchant[:data][:attributes]).to have_key(:name)
			end
		end
		describe "sad path" do
			it 'bad integer id returns 404' do
				get "/api/v1/merchants/1"

				expect(response.status).to eq(404)
			end

			it 'string id returns 404' do
				get "/api/v1/merchants/'1'"

				expect(response.status).to eq(404)
			end
		end
	end
end
