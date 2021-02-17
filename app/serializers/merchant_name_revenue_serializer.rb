class MerchantRevenueSerializer
	include FastJsonapi::ObjectSerializer
	attributes :name, :revenue
end