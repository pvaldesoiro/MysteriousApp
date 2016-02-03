class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by(username: username)
      if user && user.valid_password?(password)
        sign_in(:user, user)
        render json: { userId: user.id }, status: :ok
      else
        render json: { error: 'Insufficient permissions' },
               status: :unauthorized
      end
    end
  end

  def destroy
    if sign_out(current_user)
      render json: { message: 'Successfully signed out' }, status: :ok
    else
      render json: { error: "Couldn't sign out" }, status: :unprocessable_entity
    end
  end
end
