class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show update]

  def show
    @post = @user.post
  end

  def update
    if @user.update(profile_params)
      redirect_back fallback_location: root_url, notice: 'ユーザー情報を更新しました。'
    else
      redirect_back fallback_location: root_url, alert: 'ユーザー情報の更新に失敗しました。'
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :avatar)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
