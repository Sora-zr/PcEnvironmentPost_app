# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :guest_not_edit, only: [:edit, :update]
  before_action :guest_not_withdraw, only: %i[check withdraw]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do |resource|
      resource.avatar.attach( io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')),
                              filename: 'default_avatar.png',
                              content_type: 'image/png' )
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def check; end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_deleted: true, deleted_at: Time.current)
    reset_session
    flash[:notice] = '退会処理が完了しました。ご利用ありがとうございました。'
    redirect_to root_path
  end

  # ユーザー登録完了後のリダイレクト先
  def after_sign_up_path_for(resource)
    page_path('service_instruction')
  end

  # ユーザー情報更新後のリダイレクト先
  def after_update_path_for(resource)
    profile_url
  end

  protected

  # ゲストユーザーがメールアドレス・パスワードの変更パージへ遷移できないように
  def guest_not_edit
    if resource.email == 'guest@example.com'
      redirect_back fallback_location: root_path, alert: 'ゲストユーザーはメールアドレス・パスワードの変更を行うことができません。'
    end
  end

  # ゲストユーザーが退会処理を実行できないように
  def guest_not_withdraw
    if current_user.email == 'guest@example.com'
      redirect_back fallback_location: root_path, alert: 'ゲストユーザーは退会処理を行うことができません。'
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
