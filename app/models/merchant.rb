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
			.select('merchants.*, SUM(invoice_items.quantity) AS count')
			.merge(Invoice.shipped)
			.merge(Transaction.successful)
			.order(count: :desc)
			.group(:id)
			.limit(quantity)
	end

	def self.revenue(start_date, end_date)
		joins(invoices: [:invoice_items, :transactions])
			.merge(Invoice.shipped)
			.merge(Transaction.successful)
			.merge(Invoice.date_between(start_date, end_date))
			.sum('invoice_items.quantity * invoice_items.unit_price')
	end

end