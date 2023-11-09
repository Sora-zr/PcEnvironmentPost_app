require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザーの新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: 'テストユーザー'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button 'ユーザー登録をする'
          expect(page).to have_content 'ユーザー登録が完了しました。'
          expect(current_path).to eq root_path
        end
      end

      context 'ユーザーネームが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: nil
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button 'ユーザー登録をする'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'ユーザーネームを入力してください'
          expect(current_path).to eq new_user_registration_path
          expect(page).to have_field 'メールアドレス', with: 'test@example.com'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: 'テストユーザー'
          fill_in 'メールアドレス', with: nil
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button 'ユーザー登録をする'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(current_path).to eq new_user_registration_path
        end
      end

      context '登録済みのメールアドレスを入力' do
        it 'ユーザーの新規作成が失敗する' do
          user = create(:user)
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: 'テストユーザー'
          fill_in 'メールアドレス', with: user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button 'ユーザー登録をする'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq new_user_registration_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }


  end
end