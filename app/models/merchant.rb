class Merchant < ApplicationRecord
	has_many :items
	has_many :invoices

	validates :name, presence: true

	def self.top_earners(quantity)
		joins(invoices: [:invoice_items, :transactions])
			.select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
			.merge(Invoice.shipped)
			.merge(Transaction.successful)
			.group(:id)
			.order(revenue: :desc)
			.limit(quantity)
	end

	def self.top_sellers(quantity)
		joins(invoices: [:invoice_items, :transactions])
			.select('merchants.*, COUNT(invoice_items.quantity)')
			.merge(Invoice.shipped)
			.merge(Transaction.successful)
			.group(:id)
			.order(count: :desc)
			.limit(quantity)
	end

end