module Api
	module V1
		module Merchants
			class SearchController < ApplicationController

				def index
					merchant = Search.find_all_name(Merchant, params[:name]).first if params[:name]
					if merchant.present?
						render json: MerchantSerializer.new(merchant)
					else
						render json: { "data": {} }
					end
				end

			end
		end
	end
end
