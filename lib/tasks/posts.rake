namespace :posts do
  desc "紐づけされていない画像を削除する"
  task unattached_images: :environment do
    ActiveStorage::Blob.unattached.find_each(&:purge)
  end
end
