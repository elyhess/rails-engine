require 'rails_helper'

describe "Merchants API" do
	describe 'Merchants who sold most items' do
		before :each do
			@merchant = create(:merchant, name: "one")
			@invoice = create(:invoice, merchant: @merchant)
			@transaction1 = create(:transaction, invoice: @invoice)
			@transaction2 = create(:transaction, invoice: @invoice)
			@transaction3 = create(:transaction, invoice: @invoice)
			@invitem1 = create(:invoice_item, invoice: @invoice, quantity: 1)
			@invitem2 = create(:invoice_item, invoice: @invoice, quantity: 3)
			@invitem3 = create(:invoice_item, invoice: @invoice, quantity: 1)

			@merchant2 = create(:merchant, name: "two")
			@invoice2 = create(:invoice, merchant: @merchant2)
			@transaction4 = create(:transaction, invoice: @invoice2)
			@transaction5 = create(:transaction, invoice: @invoice2)
			@transaction6 = create(:transaction, invoice: @invoice2)
			@invitem4 = create(:invoice_item, invoice: @invoice2, quantity: 1)
			@invitem5 = create(:invoice_item, invoice: @invoice2, quantity: 2)
			@invitem6 = create(:invoice_item, invoice: @invoice2, quantity: 3)
		end
		describe "happy path" do
			it 'finds merchants who sold the most items' do
				get "/api/v1/merchants/most_items?quantity=2"

				expect(response).to be_successful
				merchant = JSON.parse(response.body, symbolize_names: true)

				expect(merchant).to be_a(Hash)
				expect(merchant[:data][0][:attributes][:name]).to eq(@merchant2.name)
				expect(merchant[:data][0][:attributes][:count]).to eq(18)
				expect(merchant[:data][1][:attributes][:name]).to eq(@merchant.name)
				expect(merchant[:data][1][:attributes][:count]).to eq(15)
			end
		end
		describe "sad path" do
			it 'quantity param is missing' do
				get "/api/v1/merchants/most_items"

				expect(response.status).to eq(400)
			end
			it 'returns error if quantity is a string' do
				get "/api/v1/merchants/most_items?quantity=striiiiiing"

				expect(response.status).to eq(400)
			end
			it 'returns error if quantity value is blank' do
				get "/api/v1/merchants/most_items?quantity="

				expect(response.status).to eq(400)
			end
		end
	end
end