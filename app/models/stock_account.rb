class StockAccount < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user
  has_one :wallet, as: :entity

  after_create :create_wallet

  private

  def create_wallet
    build_wallet.save
  end
end
