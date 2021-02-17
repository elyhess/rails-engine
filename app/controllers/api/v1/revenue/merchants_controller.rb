module Api
	module V1
		module Revenue
			class MerchantsController < ApplicationController

				def index
					if params[:quantity].present?
						merchants = Merchant.top_earners(params[:quantity])
						render json: MerchantNameRevenueSerializer.new(merchants)
					else
						render json: {error: {}}, status: 400
					end
				end

				def show
					merchant = Merchant.top_earners(1).find(params[:id])
					render json: MerchantRevenueSerializer.new(merchant)
				end

			end
		end
	end
end
