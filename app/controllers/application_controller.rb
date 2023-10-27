class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: %i[index show]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end