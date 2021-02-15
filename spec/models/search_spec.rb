require 'rails_helper'

RSpec.describe Search, type: :model do
	describe "class methods" do
		describe "::find_one" do
			it 'returns a single object if found' do
				item = create_list(:item, 10)
				named_item = create(:item, name: "Cool Item")

				search = Search.find_one(Item, "Cool Item")

				expect(search).to eq(named_item)
			end
			it 'returns a single object if partial search found' do
				item = create_list(:item, 10)
				named_item = create(:item, name: "Cool Item")

				search = Search.find_one(Item, "CoOl")

				expect(search).to eq(named_item)
			end
			it 'returns first in case-sensitive alphabet order if multiple are found' do
				named_item1 = create(:item, name: "fantastic")
				named_item2 = create(:item, name: "fandango")

				search = Search.find_one(Item, "fan")

				expect(search).to eq(named_item2)
			end
		end
	end
end