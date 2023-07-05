FactoryBot.define do
  factory :transaction do
    source_wallet_id { }
    target_wallet_id { }
    amount { }
  end
end
