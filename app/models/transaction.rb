class Transaction < ApplicationRecord
  attr_accessor :skip_wallet_id_validate

  validates :target_wallet_id, presence: true
  validates :source_wallet_id, presence: true, unless: :skip_source_wallet_id_validate?
  belongs_to :target_wallet, foreign_key: :target_wallet_id, class_name: 'Wallet'
  belongs_to :source_wallet, foreign_key: :source_wallet_id, class_name: 'Wallet', optional: true

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :transfer_amount_validation

  private

  def transfer_amount_validation
    return if source_wallet_id.blank? || self.source_wallet.balance >= self.amount.to_i
    errors.add(:amount, "Out of balance")
  end

  def skip_source_wallet_id_validate?
    return false if source_wallet_id.blank? && target_wallet_id.blank?
    skip_wallet_id_validate && target_wallet_id.present?
  end
end
