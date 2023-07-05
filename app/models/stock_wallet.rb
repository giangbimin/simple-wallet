class StockWallet < Wallet
  self.table_name = 'wallets'
  default_scope -> { where(entity_type: 'StockAccount') }
end