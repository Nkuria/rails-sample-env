class Api::V1::UsersController < Api::V1::ApiController
  def index
    render json: users
  end

  def show
    user = users.find(params[:id])
    render json: user
  end

  private

  def users
    current_company.users.select(:id, :company_id, :name, :created_at, :updated_at)
  end
end
