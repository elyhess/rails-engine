require 'rails_helper'

describe SearchFacade do
	it 'exists' do
		search = SearchFacade.new
		expect(search).to be_an_instance_of(SearchFacade)
	end

	it 'can find_all items by partial name search' do
		item = create(:item, name: 'hello')
		params = {name: "he"}
		search = SearchFacade.find_all(params, Item)
		expect(search).to eq([item])
	end

	it 'can find_all items by min price search' do
		item = create(:item, unit_price: 3.99)
		params = {min_price: 1.00}
		search = SearchFacade.find_all(params, Item)
		expect(search).to eq([item])
	end

	it 'can find_all items by max price search' do
		item = create(:item, unit_price: 3.99)
		params = {max_price: 5.00}
		search = SearchFacade.find_all(params, Item)
		expect(search).to eq([item])
	end

	it 'returns empty array if price & name queries used at the same time' do
		item = create(:item, unit_price: 3.99)
		params = {max_price: 5.00, min_price: 1.00, name: "a"}
		search = SearchFacade.find_all(params, Item)
		expect(search).to eq([])
	end
end