class AssetTransferService
  def initialize current_wallet, transaction_params
    @current_wallet = current_wallet
    @transaction = Transaction.new(transaction_params)
    @transaction.source_wallet_id = @current_wallet.id
  end

  def execute
    ActiveRecord::Base.transaction do
      @current_wallet.touch
      @transaction.save!
      {status: true, message: "Created", transaction: @transaction}
    rescue ActiveRecord::ActiveRecordError
      {status: false, message: @transaction.errors.full_messages}
    end
  end
end