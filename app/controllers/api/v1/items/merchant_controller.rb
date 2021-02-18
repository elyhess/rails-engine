module Api
	module V1
		module Items
			class MerchantController < ApplicationController

				def index
					item = Item.find(params[:item_id])
					render json: MerchantSerializer.new(item.merchant)
				end

			end
		end
	end
end