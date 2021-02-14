module Api
	module V1
		module Merchants
			class ItemsController < ApplicationController
				def index
					merchant = Merchant.find(params[:merchant_id])
					render json: ItemSerializer.new(merchant.items)
				end
			end
		end
	end
end