class Invoice < ApplicationRecord
	scope :shipped, -> { where(status: "shipped") }
	belongs_to :customer
	belongs_to :merchant

	has_many :invoice_items, dependent: :destroy
	has_many :transactions
	has_many :items, through: :invoice_items

	validates :customer_id, presence: true
	validates :merchant_id, presence: true
	validates :status, presence: true
end