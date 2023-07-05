class Wallet < ApplicationRecord
  validates :entity_id, :entity_type, presence: true

  belongs_to :entity, polymorphic: true
  has_many :withdrawals, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :deposits, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  def balance
    deposits.sum(:amount) - withdrawals.sum(:amount)
  end
end
