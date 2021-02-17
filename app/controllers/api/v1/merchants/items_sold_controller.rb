module Api
	module V1
		module Merchants
			class ItemsSoldController < ApplicationController

				def index # most items sold
					#takes a quantity paramenter
					# returns collection of x(quantity) amnt of merchants
					# most_items?quantity=5 --- top 5 merchants with most items sold
					#
					# Invoices must have a successful transaction
					# and shipped to the customer to be considered as revenue.
				end

			end
		end
	end
end
