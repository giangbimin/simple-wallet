class TeamWallet < Wallet
  self.table_name = 'wallets'
  default_scope -> { where(entity_type: 'TeamAccount') }
end