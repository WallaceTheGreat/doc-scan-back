class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :register]

  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { 
        token: token,
        user: {
          id: user.id,
          email: user.email,
          username: user.username,
          fname: user.fname,
          lname: user.lname
        }
      }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/register
  def register
    user = User.new(user_params)
    
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { 
        token: token,
        user: {
          id: user.id,
          email: user.email,
          username: user.username,
          fname: user.fname,
          lname: user.lname
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:fname, :lname, :username, :email, :password, :password_confirmation)
  end
end
