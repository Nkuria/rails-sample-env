class ApplicationController < ActionController::Base
  include Pagy::Backend

  def current_company
    @current_company ||= Company.find(params[:company_id]) if params[:company_id]
  end

  helper_method :current_company
end
