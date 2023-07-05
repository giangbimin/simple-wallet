class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[destroy]

  def create
    user_id = find_current_user_id
    return render json: {
      message: 'Sign in successful',
      user_id: user_id,
      token: AuthenticationService.generate_jwt(user_id),
      refresh_token: AuthenticationService.generate_refresh_token(user_id),
      }, status: :ok if user_id
    render json: { message: 'Invalid credentials' }, status: :unauthorized
  end

  def refresh
    user_id = params[:user_id]
    status = AuthenticationService.refresh_token_valid?(user_id, params[:refresh_token])
    return render json: {
      message: 'Refresh successful',
      user_id: user_id,
      token: AuthenticationService.generate_jwt(user_id),
      refresh_token: AuthenticationService.generate_refresh_token(user_id),
      }, status: :ok if status
    render json: { message: 'Invalid credentials' }, status: :unauthorized
  end

  def destroy
    user_id = @current_user.id
    AuthenticationService.inactive_jwt(user_id)
    AuthenticationService.inactive_refresh_token(user_id)
    render json: { message: 'Sign out successful' }, status: :ok
  end
  
  private

  def find_current_user_id
    user = User.find_by(email: params[:email])
    return user.id if user.present? && user.authenticate?(params[:password])
    user = User.new(email: params[:email], password: params[:password])
    user.id if user.save
  end
end