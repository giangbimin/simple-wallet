class Api::V1::TeamAccountsController < ApplicationController
  def create
    account = TeamAccount.new(account_params)
    account.user_id = @current_user.id
    return render json: {
      data: account.as_json(only: [:name, :id], methods: :wallet_id),
      message: 'Created'
    }, status: :created if account.save
    render json: {message: account.errors.full_messages }, status: :not_acceptable 
  end

  private
    def account_params
      params.permit(:name)
    end
end
