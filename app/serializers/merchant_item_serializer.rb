class MerchantItemSerializer
	include FastJsonapi::ObjectSerializer
	attributes :name, :count
end