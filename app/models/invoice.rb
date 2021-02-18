class Invoice < ApplicationRecord
	scope :shipped, -> { where(status: "shipped") }

	scope :date_between, -> (start_date, end_date) {
		where("invoices.created_at >= ? AND invoices.created_at < ?", start_date, end_date)}

	belongs_to :customer
	belongs_to :merchant

	has_many :invoice_items, dependent: :destroy
	has_many :transactions
	has_many :items, through: :invoice_items

	validates :customer_id, presence: true
	validates :merchant_id, presence: true
	validates :status, presence: true
end