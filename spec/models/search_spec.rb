require 'rails_helper'

RSpec.describe Search, type: :model do
	describe "class methods" do
		describe "::find_all_name" do
			it 'returns a single object via scope if found' do
				merchant = create_list(:merchant, 10)
				named_merchant = create(:merchant, name: "Cool Item")

				search = Search.find_all_name(Merchant, "Cool Item").first

				expect(search).to eq(named_merchant)
			end
			it 'returns a single object via scope if partial search found' do
				merchant = create_list(:merchant, 10)
				named_merchant = create(:merchant, name: "Cool Item")

				search = Search.find_all_name(Merchant, "CoOl").first

				expect(search).to eq(named_merchant)
			end
			it 'returns first in case-sensitive alphabet order via scope if multiple are found' do
				merchant1 = create(:merchant, name: "fantastic")
				merchant2 = create(:merchant, name: "fandango")

				search = Search.find_all_name(Merchant, "fan").first

				expect(search).to eq(merchant2)
			end
			it 'returns a collection if partial search found' do
				item1 = create(:item, name: "Cool B")
				item2 = create(:item, name: "Cool C")
				item3 = create(:item, name: "Cool A")

				search = Search.find_all_name(Item, "CoOl")

				expect(search).to eq([item3, item1, item2])
			end
		end

		describe "::find_all_price" do
			it 'returns collection with min price' do
				item1 = create(:item, unit_price: 3.99)
				item2 = create(:item, unit_price: 12.99)
				item3 = create(:item, unit_price: 5.99)

				search = Search.find_all_price(Item, 4.00, nil)

				expect(search).to eq([item3, item2])
			end
			it 'returns collection with max price defined ' do
				item1 = create(:item, unit_price: 3.99)
				item2 = create(:item, unit_price: 12.99)
				item3 = create(:item, unit_price: 5.99)

				search = Search.find_all_price(Item, nil, 5.00)

				expect(search).to eq([item1])
			end
			it 'returns a collection with both mix and max price defined' do
				item1 = create(:item, unit_price: 3.99)
				item2 = create(:item, unit_price: 12.99)
				item4 = create(:item, unit_price: 18.99)
				item3 = create(:item, unit_price: 5.99)

				search = Search.find_all_price(Item, 2.99, 15.00)

				expect(search).to eq([item1, item3, item2])
			end
		end
	end
end