require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザーの新規登録' do
      context '全てのフォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: 'テストユーザー'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '新規登録'
          sleep 1
          expect(page).to have_content 'ユーザー登録が完了しました。'
          expect(current_path).to eq posts_path
        end
      end

      context 'ユーザーネームが空白' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: '　'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '新規登録'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'ユーザーネームを入力してください'
          expect(current_path).to eq new_user_registration_path
          expect(page).to have_field 'メールアドレス', with: 'test@example.com'
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
          click_button '新規登録'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq new_user_registration_path
        end
      end

      context 'パスワードとパスワード確認が一致しない' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'ユーザーネーム', with: 'テストユーザー'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'PASSWORD'
          click_button '新規登録'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          expect(current_path).to eq new_user_registration_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }

    describe 'ユーザー情報の編集（プロフィール画像、ユーザーネーム）' do
      context '入力値が正常' do
        it 'ユーザー情報の更新に成功する' do
          visit profile_path
          fill_in 'ユーザーネーム', with: 'TestUser'
          attach_file 'プロフィール画像', Rails.root.join('spec', 'fixtures', 'test_image.jpg')
          click_button '更新'
          expect(page).to have_content 'ユーザー情報を更新しました。'
          expect(current_path).to eq profile_path
        end
      end

      context 'ユーザーネームの入力値が空白' do
        it 'ユーザー情報の更新に失敗する' do
          visit profile_path
          fill_in 'ユーザーネーム', with: '　'
          click_button '更新'
          expect(page).to have_content 'ユーザー情報の更新に失敗しました。'
          expect(current_path).to eq profile_path
        end
      end
    end

    describe 'ユーザー情報の編集（メールアドレス、パスワード）' do
      context 'メールアドレス、パスワードの入力値が正常' do
        it 'ユーザー情報の更新に成功する' do
          visit edit_user_registration_path
          fill_in 'メールアドレス', with: 'Test@example.com'
          fill_in 'パスワード', with: 'PASSWORD'
          fill_in 'パスワード確認', with: 'PASSWORD'
          fill_in '現在のパスワードをご入力してください', with: user.password
          click_button 'ユーザー情報を更新'
          sleep 1
          expect(page).to have_content 'ユーザー情報を更新しました。'
          expect(current_path).to eq profile_path
        end
      end

      context 'メールアドレスの入力値が正常' do
        it 'ユーザー情報の更新に成功する' do
          visit edit_user_registration_path
          fill_in 'メールアドレス', with: 'Test@example.com'
          fill_in '現在のパスワードをご入力してください', with: user.password
          click_button 'ユーザー情報を更新'
          sleep 1
          expect(page).to have_content 'ユーザー情報を更新しました。'
          expect(current_path).to eq profile_path
        end
      end

      context 'パスワードの入力値が正常' do
        it 'ユーザー情報の更新に成功する' do
          visit edit_user_registration_path
          fill_in 'パスワード', with: 'PASSWORD'
          fill_in 'パスワード確認', with: 'PASSWORD'
          fill_in '現在のパスワードをご入力してください', with: user.password
          click_button 'ユーザー情報を更新'
          sleep 1
          expect(page).to have_content 'ユーザー情報を更新しました。'
          expect(current_path).to eq profile_path
        end
      end

      context 'パスワードとパスワード確認が一致しない' do
        it 'ユーザー情報の更新に失敗する' do
          visit edit_user_registration_path
          fill_in 'メールアドレス', with: 'Test@example.com'
          fill_in 'パスワード', with: 'PASSWORD'
          fill_in 'パスワード確認', with: 'password'
          fill_in '現在のパスワードをご入力してください', with: user.password
          click_button 'ユーザー情報を更新'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          expect(current_path).to eq edit_user_registration_path
        end
      end

      context '現在のパスワードが入力されていない' do
        it 'ユーザー情報の更新に失敗する' do
          visit edit_user_registration_path
          fill_in 'メールアドレス', with: 'Test@example.com'
          click_button 'ユーザー情報を更新'
          expect(page).to have_content '1 件のエラーが発生したため ユーザー は保存されませんでした。'
          expect(page).to have_content '現在のパスワードを入力してください'
          expect(current_path).to eq edit_user_registration_path
        end
      end
    end
  end

  describe 'ゲストユーザー' do
    context 'ゲストユーザーはメールアドレス・パスワード変更画面に遷移することができない' do
      it '画面遷移に失敗する' do
        visit user_session_path
        find('#guest-login-button').click
        page.driver.browser.switch_to.alert.accept
        sleep 1
        expect(page).to have_content 'ゲストユーザーとしてログインしました。'
        expect(current_path).to eq posts_path
        visit edit_user_registration_path
        expect(page).to have_content 'ゲストユーザーはメールアドレス・パスワードの変更を行うことができません。'
      end
    end

    context 'ゲストユーザーは退会画面に遷移することができない' do
      it '画面遷移に失敗する' do
        visit user_session_path
        find('#guest-login-button').click
        page.driver.browser.switch_to.alert.accept
        sleep 1
        expect(page).to have_content 'ゲストユーザーとしてログインしました。'
        expect(current_path).to eq posts_path
        visit users_check_path
        expect(page).to have_content 'ゲストユーザーは退会処理を行うことができません。'
      end
    end
  end
end