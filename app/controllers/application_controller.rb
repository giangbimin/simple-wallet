class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    return if token && valid_token?(token)
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end

  def valid_token?(token)
    @payload = AuthenticationService.decode_jwt(token)
    return false if @payload.blank?
    return false unless AuthenticationService.jwt_active?(@payload["user_id"], token)
    find_current_user
    @current_user.present?
  end

  def find_current_user
    @current_user = User.find_by(id: @payload["user_id"])
  end
end
