require 'rails_helper'

describe "Merchants Revenue API" do
	before(:each) do
		@transaction1 = create(:transaction)
		@transaction2 = create(:transaction, invoice: @transaction1.invoice)
		@transaction3 = create(:transaction, invoice: @transaction1.invoice)
		@transaction4 = create(:transaction)
		4.times do
			create(:invoice_item, invoice: @transaction1.invoice, quantity: 1, unit_price: 25)
		end
		10.times do
			create(:invoice_item, invoice: @transaction4.invoice, quantity: 2, unit_price: 100)
		end
	end
	describe "Merchants Revenue Index" do
		describe "happy path" do
			it 'it fetches merchants by revenue with quantity specified' do
				get "/api/v1/revenue/merchants?quantity=3"

				expect(response).to be_successful

				merchants = JSON.parse(response.body, symbolize_names: true)

				expect(merchants).to be_a(Hash)
				expect(merchants[:data].count).to eq(2)
				merchants[:data].each do |merchant|
					expect(merchant[:attributes][:revenue]).to be_a(Float)
					expect(merchant[:attributes][:name]).to be_a(String)
				end
			end
		end
		describe "sad path" do
			it 'returns an error of some sort if quantity value is invalid' do
				get "/api/v1/revenue/merchants?quantity="

				expect(response.status).to eq(400)

				get "/api/v1/revenue/merchants?quantity"

				expect(response.status).to eq(400)

				get "/api/v1/revenue/merchants"

				expect(response.status).to eq(400)

				get "/api/v1/revenue/merchants?quantity=striiiing"

				expect(response.status).to eq(400)
			end
		end
	end


	describe "Merchant Revenue Show" do
		describe "happy path" do
			it 'can fetch total revenue for one merchant' do
				get "/api/v1/revenue/merchants/#{@transaction1.invoice.merchant.id}"

				expect(response).to be_successful

				merchant = JSON.parse(response.body, symbolize_names: true)

				expect(merchant).to be_a(Hash)
				expect(merchant.count).to eq(1)
				expect(merchant[:data][:attributes][:revenue]).to eq(300.0)
				expect(merchant[:data][:attributes]).to_not have_key(:name)
			end
		end
		describe "sad path" do
			it 'bad integer id returns 404' do
				get "/api/v1/revenue/merchants/1231231231"

				expect(response.status).to eq(404)
			end
		end
	end

end