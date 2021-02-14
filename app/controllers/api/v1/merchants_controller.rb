module Api
	module V1
		class MerchantsController < ApplicationController

			def index
				merchants = paginate(Merchant.all)
				render json: MerchantSerializer.new(merchants)
			end

			def show
				merchant = Merchant.find(params[:id])
				render json: MerchantSerializer.new(merchant)
			end

		end
	end
end