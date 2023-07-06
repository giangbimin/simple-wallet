class PersonalAccount < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user
  has_one :wallet, as: :entity, class_name: 'PersonalWallet'

  after_create :create_wallet

  def wallet_id
    wallet.id
  end

  private

  def create_wallet
    build_wallet.save
  end
end
