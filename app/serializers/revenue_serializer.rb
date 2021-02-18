class RevenueSerializer

	def self.total_revenue(revenue)
		{ data: { id: nil, type: 'revenue', attributes: { revenue: revenue } } }
	end

end