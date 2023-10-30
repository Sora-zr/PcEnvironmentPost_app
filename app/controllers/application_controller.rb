class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[avatar name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar name])
  end
end