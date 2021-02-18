require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe "class methods" do
    describe "::top_earners" do
      it 'returns top earners via specified quantity' do
	      invoice = create(:invoice)
	      transaction1 = create(:transaction, invoice: invoice)
	      transaction2 = create(:transaction, invoice: invoice)
	      transaction3 = create(:transaction, invoice: invoice)
	      invitem1 = create(:invoice_item, invoice: invoice, unit_price: 5)
	      invitem2 = create(:invoice_item, invoice: invoice, unit_price: 10)
	      invitem3 = create(:invoice_item, invoice: invoice, unit_price: 15)

        invoice2 = create(:invoice)
        transaction4 = create(:transaction, invoice: invoice2)
        transaction5 = create(:transaction, invoice: invoice2)
        transaction6 = create(:transaction, invoice: invoice2)
        invitem4 = create(:invoice_item, invoice: invoice2, unit_price: 50)
        invitem5 = create(:invoice_item, invoice: invoice2, unit_price: 100)
        invitem6 = create(:invoice_item, invoice: invoice2, unit_price: 50)

        expect(Merchant.top_earners(2)).to eq([invoice2.merchant, invoice.merchant])
	      expect(Merchant.top_earners(1)).to eq([invoice2.merchant])
      end
    end
    describe "::top_sellers" do
	    it 'returns merchants with most sold items' do
		    invoice = create(:invoice)
		    transaction1 = create(:transaction, invoice: invoice)
		    transaction2 = create(:transaction, invoice: invoice)
		    transaction3 = create(:transaction, invoice: invoice)
		    invitem1 = create(:invoice_item, invoice: invoice, unit_price: 5, quantity: 10)
		    invitem2 = create(:invoice_item, invoice: invoice, unit_price: 10, quantity: 20)
		    invitem3 = create(:invoice_item, invoice: invoice, unit_price: 15, quantity: 30)

		    invoice2 = create(:invoice)
		    transaction4 = create(:transaction, invoice: invoice2)
		    transaction5 = create(:transaction, invoice: invoice2)
		    transaction6 = create(:transaction, invoice: invoice2)
		    invitem4 = create(:invoice_item, invoice: invoice2, unit_price: 5, quantity: 2)
		    invitem5 = create(:invoice_item, invoice: invoice2, unit_price: 10, quantity: 3)
		    invitem6 = create(:invoice_item, invoice: invoice2, unit_price: 15, quantity: 100)

		    expect(Merchant.top_sellers(3)).to eq([invoice2.merchant, invoice.merchant])
	    end
    end
    describe "::revenue" do
	    it 'should return revenue between dates provided' do
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

		    expect(Merchant.revenue("Sun, 31 Jan 2021", "Sun, 07 Feb 2021")).to eq(90.0)
		    expect(Merchant.revenue("Sun, 31 Jan 2021", "Sun, 04 Feb 2021")).to eq(30.0)
	    end
    end
  end
end