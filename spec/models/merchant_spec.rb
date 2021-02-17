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
  end
end