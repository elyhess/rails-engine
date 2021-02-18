module Api
	module V1
		class RevenueController < ApplicationController

			def index
				if params[:start].present? && params[:end].present?
					all_merchant_revenue = RevenueFacade.by_date(revenue_params)
					render json: RevenueSerializer.total_revenue(all_merchant_revenue)
				else
					render json: {error: {}}, status: 400
				end
			end

			private

			def revenue_params
				params.permit(:start, :end)
			end

		end
	end
end
