class UsersController < ApplicationController
    before_action :authenticate_user, only: [:update_user, :delete_user]
    
    def create_user
        if User.find_by(email: user_params[:email])
            render json: { error: 'User with this email already exists' }, status: :unprocessable_entity
        end    

        if user_params[:password] != user_params[:confirm_password]
            render json: {error: "Password and Confirm password don't match"}, status: :unprocessable_entity
        end

        @user = User.new(
            name: user_params[:name],
            email: user_params[:email],
            password: user_params[:password],
            bio: user_params[:bio]
        )

        if @user.save
            token = JWT.encode({ user_id: @user.id }, Rails.application.config.jwt_secret, 'HS256')
            render json: { token: token, message: 'User Create successfully' }, status: :created
        else
            render json: {error: @user.errors.full_messages }, status: :unprocessable_entity
        end    
    end

    def update_user
        user = current_user

        if user.update(user_params)
            render json: { message: 'User updated successfully' }, status: :ok
        else
            render json: {error: @user.errors.full_messages }, status: :unprocessable_entity  
        end
    end

    def delete_user
        user = current_user

        if user.destroy
            render json: { message: 'User Deleted successfully' }, status: :ok
        else
            render json: {error: @user.errors.full_messages }, status: :unprocessable_entity  
        end    
    end

    def user_params
        params.permit(:name, :email, :password, :confirm_password, :bio)
    end
end
