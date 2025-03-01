class Api::V1::ApiController < ApplicationController
  class BadRequest < StandardError; end
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, NotFound, with: :render_404
  rescue_from BadRequest, with: :render_400
  rescue_from Unauthorized, with: :render_401
  rescue_from Forbidden, with: :render_403

  include Api::V1::LoginAuth

  protect_from_forgery with: :null_session
  before_action :login_auth_token
  before_action :check_api_rate_limit
  after_action :create_api_request_log

  def login_auth_token
    token = extract_token
    raise Unauthorized.new('login required') unless token

    @user_id = decode_jwt(token)[0]['data']['user']['id']
  rescue JWT::VerificationError => e
    logger.error e.message
    render json: { status: 401, message: e.message }, status: :unauthorized
  rescue JWT::ExpiredSignature => e
    logger.error e.message
    render json: { status: 401, message: e.message }, status: :unauthorized
  end

  private

  def check_api_rate_limit
    if current_company.api_request_logs.where(created_at: Time.zone.now.all_day).count > 1000 # current_company.daily_request_limit_api
      @limit_status = 'daily limit exceeded'
      render json: { status: 429, message: 'API request limit exceeded' }, status: :too_many_requests
      create_api_request_log
      return
    end
    result = buckets_status
    return if result.dig(:status)

    @limit_status = result&.dig(:description)
    render json: { status: 429, message: 'API request limit exceeded' }, status: :too_many_requests
    create_api_request_log
  end

  def buckets_status(current_time: Time.zone.now)
    success = true
    gcra_setting_name = nil
    GcraSetting.transaction do
      current_company.gcra_settings.each do |gcra_setting|
        gcra_setting_name = gcra_setting.name
        if current_time > gcra_setting.tat
          gcra_setting.update(tat: current_time + gcra_setting.emission_interval)
          next
        end

        if current_time + gcra_setting.max_process_time > gcra_setting.tat
          gcra_setting.update(tat: gcra_setting.tat + gcra_setting.emission_interval)
        else
          success = false
          raise ActiveRecord::Rollback
        end
      end
    end
    gcra_setting_name = 'OK' if success
    { status: success, description: gcra_setting_name }
  end

  def create_api_request_log
    p "limit status: #{@limit_status}"
    ApiRequestLog.create(
      company: current_company,
      user: current_user,
      path: request.path,
      method: request.method,
      action: action_name,
      controller: controller_name,
      request_body: request.raw_post,
      status: response.status,
      limit_status: @limit_status || 'none'
    )
  end

  def current_user
    @current_user ||= User.find(@user_id) if @user_id.present?
  end

  def current_company
    @current_company ||= Company.find(current_user&.company_id) if current_user.present?
  end

  # Error handling
  def render_400(exception = nil)
    render json: { status: 400, message: exception.message }, status: :bad_request
  end

  def render_401(exception = nil)
    render json: { status: 401, message: exception.message }, status: :unauthorized
  end

  def render_403(exception = nil)
    render json: { status: 403, message: exception.message }, status: :forbidden
  end

  def render_404(exception = nil)
    render json: { status: 404, message: exception.message }, status: :not_found
  end
end
