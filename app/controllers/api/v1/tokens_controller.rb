class Api::V1::TokensController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    response.headers.merge!({
      'Pragma'        => 'no-cache',
      'Cache-Control' => 'no-store',
    })

    if @user = User.where(email: params[:email]).first
      @user.ensure_authentication_token!

      if @user.valid_password?(params[:password])
        render json: { access_token: @user.authentication_token }
      # elsif request.method == 'OPTIONS'
      #   render nothing: true
      else
        render nothing: true, status: 401
      end
    else
      render nothing: true, status: 401
    end
  end

  def destroy
    @user = User.where(authentication_token: params[:id]).first
    if @user.nil?
      render nothing: true, status: 404
    else
      @user.reset_authentication_token!
      render json: { access_token: params[:id] }
    end
  end
end
