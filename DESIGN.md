## Database Design

The wallet system's database design consists of the following tables:

1. `users`: Stores information about users.
2. `teams`: Stores information about teams.
3. `stocks`: Stores information about stocks.
4. `wallets`: Stores wallet information, including the owner's ID, owner type, and balance.
5. `transactions`: Stores transaction details, including the wallet ID, transaction type, amount, source wallet ID, target wallet ID, and timestamps.

## Associations

The following associations exist between the entities and the wallet system:

1. User Model:
   - has_one :wallet, as: :owner

2. Team Model:
   - has_one :wallet, as: :owner

3. Stock Model:
   - has_one :wallet, as: :owner

4. Wallet Model:
   - belongs_to :owner, polymorphic: true
   - has_many :transactions

5. Transaction Model:
   - belongs_to :wallet
   - belongs_to :source_wallet, class_name: 'Wallet', optional: true
   - belongs_to :target_wallet, class_name: 'Wallet', optional: true

## Functionality

The wallet system provides the following functionality:

1. Deposits: Money can be deposited into a wallet associated with an entity (User, Team, Stock) by creating appropriate deposit transactions.
2. Withdrawals: Money can be withdrawn from a wallet associated with an entity by creating withdrawal transactions.
3. Transfers = Deposits to source_wallet_id and Withdrawals from target_wallet_id

## Balance Calculation

The balance for each entity (User, Team, Stock) is calculated by summing the transaction amounts associated with their respective wallets.

## DB Design:
### Entities:
  Define the various entities that can have a wallet, such as User, Stock, Team, etc. Each entity should have its own unique identifier (e.g., user_id, stock_id) and any other relevant attributes.
### Wallets:
  Create a Wallet model that represents the wallet associated with an entity. The Wallet model should have the following attributes:
- owner_type: The type of entity associated with the wallet (e.g., "User", "Stock", "Team").
- owner_id: The ID of the associated entity.
- balance: The current balance of the wallet.
### Transactions:
  Create a Transfer model to record money transactions within the wallet system. The Transaction model should have the following attributes:
- amount: The amount of money involved in the transaction.
- source_wallet_id: The ID of the source wallet in case of transfers.
- target_wallet_id: The ID of the target wallet in case of transfers.
- timestamp: The timestamp of the transaction.
