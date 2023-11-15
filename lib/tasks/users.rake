namespace :users do
  desc "退会してから30日経過したユーザーが存在する場合、物理削除を行う"
  task delete_after_10_days: :environment do
    User.deleted_user.destroy_all
  end
end
