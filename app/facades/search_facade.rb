class SearchFacade
	class << self

		def find_all(params, resource)
			if params[:name].present? && !(params[:min_price] || params[:max_price])
				Search.find_all_name(resource, params[:name])
			elsif !params[:name]
				Search.find_all_price(resource, params[:min_price], params[:max_price])
			else
				[]
			end
		end

	end
end