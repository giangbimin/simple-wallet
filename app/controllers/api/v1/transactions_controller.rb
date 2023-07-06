class Api::V1::TransactionsController < ApplicationController
  before_action :find_wallet, :authorize_wallet!, only: [:create]
  before_action :find_transaction, only: [:show]
  
  def show
    render json: {
      data: @transaction.as_json(only: [:id, :source_wallet_id, :target_wallet_id, :amount])
    }, status: :ok
  end

  def create
    service = AssetTransferService.new(@wallet, transaction_params)
    response = service.execute
    return render json: {
      data: response[:transaction].as_json(only: [:id, :source_wallet_id, :target_wallet_id, :amount]),
      message: response[:message]
    }, status: :created if response[:status]
    render json: {message: response[:message]}, status: :not_acceptable 
  end
  
  private
    def authorize_wallet!
      return if @wallet.entity.user_id == @current_user.id
      render json: { message: 'Wallet Unauthorized' }, status: :unauthorized
    end

    def find_wallet
      @wallet = Wallet.find_by(id: params[:id])
      render json: { message: 'Not Found' }, status: :not_found if @wallet.blank?
    end

    def find_transaction
      @transaction = Transaction.find_by(id: params[:id])
      render json: { message: 'Not Found' }, status: :not_found if @transaction.blank?
    end

    def transaction_params
      params.permit(:target_wallet_id, :amount)
    end
end
