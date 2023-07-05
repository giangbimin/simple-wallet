class PersonalWallet < Wallet
  self.table_name = 'wallets'
  default_scope -> { where(entity_type: 'PersonalAccount') }
end