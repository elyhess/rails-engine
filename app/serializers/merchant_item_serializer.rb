class MerchantItemsSerializer
	include FastJsonapi::ObjectSerializer
	attributes :name, :count
end