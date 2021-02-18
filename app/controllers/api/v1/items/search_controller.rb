module Api
	module V1
		module Items
			class SearchController < ApplicationController

				def index
					search = SearchFacade.find_all(params, Item)
					if params[:name] && (params[:min_price] || params[:max_price])
						render json: { "error" => {} }, status: 404
					else
						render json: ItemSerializer.new(search)
					end
				end

			end
		end
	end
end
