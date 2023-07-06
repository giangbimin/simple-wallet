user = User.create(email: 'test1@example.com', password: 'password')
PersonalAccount.create(name: "PersonalAccount", user_id: user.id)
StockAccount.create(name: "StockAccount", user_id: user.id)
TeamAccount.create(name: "TeamAccount", user_id: user.id)
wallets = Wallet.all
ActiveRecord::Base.transaction do
  wallets.each do |wallet|
    Transaction.create(source_wallet_id: nil, target_wallet_id: wallet.id, amount: 100, skip_wallet_id_validate: true)
  end
end
wallet_ids = Wallet.pluck(:id)
amounts = (0..100).to_a
wallet_ids.each do |cur_id|
  ids = wallet_ids - [cur_id]
  ids.each do |id|
    Transaction.create(source_wallet_id: cur_id, target_wallet_id: id, amount: amounts.sample)
  end
end
