class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[destroy]
  before_action :validate_refresh_token, only: %i[refresh]

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
    user_id = @payload["user_id"]
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

  def validate_refresh_token
    refresh_token = params[:refresh_token]
    return render json: { message: 'Invalid credentials of refresh_token' }, status: :not_found unless refresh_token
    @payload = AuthenticationService.decode_jwt(refresh_token)
    return render json: { message: 'Invalid credentials of refresh_token' }, status: :unauthorized if @payload.blank?
    return render json: { message: 'Invalid credentials of refresh_token' }, status: :unauthorized unless
      AuthenticationService.refresh_token_active?(@payload["user_id"], refresh_token)
    @payload
  end
end