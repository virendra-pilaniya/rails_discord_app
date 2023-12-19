class ApplicationController < ActionController::Base
    protect_from_forgery unless: -> { request.format.json? }
    
    def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        decoded_token = JWT.decode(token, Rails.application.config.jwt_secret, true, algorithm: 'HS256')
    
        user_id = decoded_token.first['user_id']
        @current_user = User.find_by(id: user_id)
    
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
    end

    def current_user
        @current_user
    end
end
