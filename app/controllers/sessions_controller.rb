class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
  
  def destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end

end