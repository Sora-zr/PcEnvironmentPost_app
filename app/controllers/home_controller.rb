class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def top
    @user = current_user
  end
end
