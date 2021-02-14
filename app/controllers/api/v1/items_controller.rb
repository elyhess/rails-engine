module Api
	module V1
		class ItemsController < ApplicationController
			before_action :find_item, only: [:show, :update]

			def index
				items = paginate(Item.all)
				render json: ItemSerializer.new(items)
			end

			def show
				render json: ItemSerializer.new(@item)
			end

			def create
				item = Item.create!(item_params)
				render json: ItemSerializer.new(item), status: 201
			end

			def update
				@item.update!(item_params)
				render json: ItemSerializer.new(@item)
			end

			def destroy
				Item.destroy(params[:id])
			end

			private

			def find_item
				@item = Item.find(params[:id])
			end

			def item_params
				params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
			end

		end
	end
end
