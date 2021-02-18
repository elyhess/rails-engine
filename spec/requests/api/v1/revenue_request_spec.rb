require 'rails_helper'

describe "Revenue API" do
	before :each do
		@merchant = create(:merchant)
		@item = create(:item, merchant: @merchant)

		@invoice1 = create(:invoice, merchant: @merchant, created_at: "Thu, 1 Feb 2021 01:47:44 UTC +00:00")
		@invoice1_a = create(:invoice, merchant: @merchant, created_at: "Thu, 6 Feb 2021 01:47:44 UTC +00:00")
		@invoice2 = create(:invoice, merchant: @merchant, status: "pending", created_at: "Thu, 1 Feb 2021 01:47:44 UTC +00:00")
		@invoice3 = create(:invoice, merchant: @merchant, status: "in progress", created_at: "Thu, 1 Feb 2021 01:47:44 UTC +00:00")

		@tran1 = create(:transaction, invoice: @invoice1)
		@tran1_a = create(:transaction, invoice: @invoice1_a)
		@tran2 = create(:transaction, invoice: @invoice2)
		@tran3 = create(:transaction, invoice: @invoice3)
		3.times do
			create(:invoice_item, item: @item, invoice: @invoice1, quantity: 2, unit_price: 5)
		end
		3.times do
			create(:invoice_item, item: @item, invoice: @invoice1_a, quantity: 2, unit_price: 10)
		end
		4.times do
			create(:invoice_item, item: @item, invoice: @invoice2, quantity: 10, unit_price: 10)
		end
		5.times do
			create(:invoice_item, item: @item, invoice: @invoice3, quantity: 2, unit_price: 2)
		end
	end

	describe "Revenue Index" do
		describe "happy path" do
			it 'Returns total revenue within a specified date range' do
				get '/api/v1/revenue?start=2021-02-01&end=2021-02-7'

				revenue = JSON.parse(response.body, symbolize_names: true)

				expect(response).to be_successful


				expect(revenue).to be_a(Hash)
				expect(revenue[:data]).to be_a(Hash)
				expect(revenue[:data][:id]).to be_nil
				expect(revenue[:data][:type]).to eq("revenue")
				expect(revenue[:data][:attributes]).to have_key(:revenue)
				expect(revenue[:data][:attributes][:revenue]).to eq(90.0)
			end
		end
		describe "sad path" do
			it 'start date is missing or end date missing' do
				get '/api/v1/revenue?end=2021-02-7'

				expect(response.status).to eq(400)

				get '/api/v1/revenue?start=2021-02-7'

				expect(response.status).to eq(400)
			end

			it 'no params are provided' do
				get '/api/v1/revenue'

				expect(response.status).to eq(400)
			end

			it 'start date is blank or end date is blank' do
				get '/api/v1/revenue?start=&end='

				expect(response.status).to eq(400)

				get '/api/v1/revenue?start=&end=2021-02-7'

				expect(response.status).to eq(400)

				get '/api/v1/revenue?start=2021-02-7&end='

				expect(response.status).to eq(400)
			end
		end
	end
end