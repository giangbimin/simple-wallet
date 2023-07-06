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


# Test Acid Transaction
Transaction.create(source_wallet_id: nil, target_wallet_id: 1, amount: 100, skip_wallet_id_validate: true)
current_balance = Wallet.first.balance

def create_transaction
  Transaction.create(source_wallet_id: 1, target_wallet_id: 2, amount: 60)
end


threads = []
10.times {
  threads << Thread.new { create_transaction }
}
threads.each(&:join)

### ACID

def new_create_transaction
  @wallet = Wallet.first
  ActiveRecord::Base.transaction do
    @wallet.touch
    Wallet.first.withdrawals.create(target_wallet_id: 2, amount: 60)
  end
end


threads = []
10.times {
  threads << Thread.new { new_create_transaction }
}
threads.each(&:join)


### with Class
def asset_transfer
  @wallet = Wallet.first
  ActiveRecord::Base.transaction do
    service = AssetTransferService.new(@wallet, {target_wallet_id: 2, amount: 60})
    service.execute
  end
end


threads = []
10.times {
  threads << Thread.new { asset_transfer }
}
threads.each(&:join)