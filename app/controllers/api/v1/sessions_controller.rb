class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :login_auth_token, :check_api_rate_limit, only: [:create]
  skip_after_action :create_api_request_log, only: [:create]

  def create
    if params[:api_key] && params[:api_secret]
      user = User.find_by(api_key: params[:api_key],
                          api_secret: params[:api_secret])
    end
    authorize_error_message = authorize_user user
    raise Unauthorized, authorize_error_message[:message] if authorize_error_message

    jwt = generate_jwt({ user: { id: user.id } })
    render json: { access_token: jwt }, status: :created
  end

  private

  def authorize_user(user)
    { code: :unauthorized, message: 'Cannot authorize with this service' } unless user
    # 他のメッセージを返す場合は、以下に条件を追加していく
  end
end
