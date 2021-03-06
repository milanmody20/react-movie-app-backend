class Api::V1::RegistrationsController < ApplicationController
    respond_to :json
    before_action :verify_jwt_token, except: :create
    def create
      @user = User.new(sign_up_params)
      if @user.save && @user.valid?
        render json: { success: true}
      else
        render json: { error: @user.errors }, status: 422
      end
    end
  
    def update
      @user = current_user
      if @user.update_attributes(sign_up_params) && @user.valid?
        render(json: Api::V1::UserSerializer.new(@user).to_h.merge(status: 200))
      else
        render(json: Api::V1::UserSerializer.new(@user).to_h.merge(status: 400))
      end
    end
  
    def destroy
      resource = current_user
      resource.destroy
      head :ok
    end
  
  
    private
  
  
    def sign_up_params
      params.require(:user).permit(:email, :password, :name)
    end
  
  end
