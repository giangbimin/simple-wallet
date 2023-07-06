class Api::V1::TransactionsController < ApplicationController
  before_action :find_wallet, :authorize_wallet!, only: [:create]
  before_action :find_transaction, only: [:show]
  
  def show
    render json: {
      data: @transaction.as_json(only: [:id, :source_wallet_id, :target_wallet_id, :amount])
    }, status: :ok
  end

  def create
    transaction = Transaction.new(transaction_params)
    transaction.source_wallet_id = @wallet.id
    return render json: {
      data: transaction.as_json(only: [:id, :source_wallet_id, :target_wallet_id, :amount]),
      message: 'Created'
    }, status: :created if transaction.save
    render json: {message: transaction.errors.full_messages }, status: :not_acceptable 
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
