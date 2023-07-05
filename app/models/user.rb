require 'digest'

class User < ApplicationRecord
  attr_accessor :password
  
  has_many :personal_accounts
  has_many :stock_accounts
  has_many :team_accounts

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  before_save :set_password_digest

  def authenticate?(input_password)
    self.password_digest == generate_hash_password(input_password)
  end

  private

  def set_password_digest
    return unless self.password
    self.password_digest = generate_hash_password(self.password)
  end

  def generate_hash_password password
    Digest::SHA256.hexdigest(password + Rails.application.secret_key_base)
  end
end
