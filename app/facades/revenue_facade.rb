class RevenueFacade
	class << self
		def by_date(params)
			start_date = Date.parse(params[:start])
			end_date = Date.parse(params[:end]).end_of_day
			Merchant.revenue(start_date, end_date)
		end
	end
end
