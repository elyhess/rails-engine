module Api
	module V1
		module Merchants
			class SearchController < ApplicationController

				def index
					merchant = Search.find_one(Merchant, params[:name]) if params[:name]
					if merchant
						render json: MerchantSerializer.new(merchant)
					else
						render json: { "data": {} }
					end
				end

			end
		end
	end
end
