require 'rails_helper'

describe RevenueFacade do
	it 'exists' do
		revenue = RevenueFacade.new
		expect(revenue).to be_an_instance_of(RevenueFacade)
	end

	it 'can return revenue by date' do
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

		params = {start: "2021-01-31", end: "2021-02-7"}
		revenue = RevenueFacade.by_date(params)

		expect(revenue).to eq(90.0)
	end

end