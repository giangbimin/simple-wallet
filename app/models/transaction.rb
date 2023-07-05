class Transaction < ApplicationRecord
  attr_accessor :skip_wallet_id_validate
  validates :source_wallet_id, presence: true, unless: :skip_source_wallet_id_validate?
  validates :target_wallet_id, presence: true, unless: :skip_target_wallet_id_validate?
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def skip_source_wallet_id_validate?
    return false if source_wallet_id.blank? && target_wallet_id.blank?
    skip_wallet_id_validate && target_wallet_id.present?
  end

  def skip_target_wallet_id_validate?
    return false if source_wallet_id.blank? && target_wallet_id.blank?
    skip_wallet_id_validate && source_wallet_id.present?
  end
end
