# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_deleted_user, only: %i[create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  # super
  # end

  # DELETE /resource/sign_out
  def destroy
    if current_user.email == 'guest@example.com'
      current_user.destroy!
    end
    super
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_url
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_url
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_url, notice: t('devise.sessions.guest_sign_in')
  end

  protected

  # 退会済みのアカウントか確認するメソッド
  def reject_deleted_user
    @user = User.find_by(email: params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false)
        flash[:alert] = '退会済みのアカウントです。再度ご登録してご利用ください。'
        redirect_to new_user_session_path
      else
        flash[:alert] = '項目を入力してください。'
      end
    else
      flash[:alert] = '該当するユーザーが見つかりませんでした。'
    end
  end
  
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  #

end
