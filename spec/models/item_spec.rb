require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name}
    it { should validate_presence_of :description}
    it { should validate_presence_of :unit_price}
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "instance methods" do
	  describe '#remove_invoices' do
      it 'deletes only the item if there are other items on the invoice' do
        item = create(:item)
        invoice = create(:invoice)
        invoice_item = create(:invoice_item, item: item, invoice: invoice)
        invoice_item2 = create(:invoice_item, invoice: invoice)

        expect(item.remove_invoices).to eq([])
        expect(Invoice.count).to eq(1)
      end
      it 'deletes invoice if it has no other items on the invoice' do
        item = create(:item)
        invoice = create(:invoice)
        invoice_item = create(:invoice_item, item: item, invoice: invoice)

        expect(item.remove_invoices).to eq([invoice])
        expect(Invoice.count).to eq(0)
      end
    end
  end
end