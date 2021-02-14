class Item < ApplicationRecord
	belongs_to :merchant

	has_many :invoice_items, dependent: :destroy
	has_many :invoices, through: :invoice_items
	has_many :transactions, through: :invoices

	validates :name, presence: true
	validates :unit_price, presence: true
	validates :description, presence: true

	before_destroy :remove_invoices, prepend: true

	def remove_invoices
		invoices
			.joins(:invoice_items)
			.group(:id)
			.having('COUNT(invoice_items.item_id) <= 1')
			.destroy_all
	end

end