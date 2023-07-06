class Api::V1::WalletsController < ApplicationController
  before_action :find_wallet, :authorize_wallet!

  def show
    render json: {
      data: @wallet.as_json(only: [:id], methods: :balance),
    }, status: :ok
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
end
