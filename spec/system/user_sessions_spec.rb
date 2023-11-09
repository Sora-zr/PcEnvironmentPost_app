require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do

    context 'フォームの入力値が正常' do
      it '正常にログインできる' do
        visit user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        find('#login-button').click
        expect(page).to have_content 'ログインしました。'
        expect(current_path).to eq root_path
      end
    end

    context 'フォームが未入力' do
      it 'ログインに失敗する' do
        visit user_session_path
        fill_in 'メールアドレス', with: nil
        fill_in 'パスワード', with: nil
        find('#login-button').click
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq user_session_path
      end
    end

    context 'パスワードの値が正しくない' do
      it 'ログインに失敗する' do
        visit user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'PASSWORD'
        find('#login-button').click
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
        expect(current_path).to eq user_session_path
        expect(page).to have_field 'メールアドレス', with: user.email
      end
    end

    context 'ゲストユーザーとしてログインする' do
      it 'ログインに成功する' do
        visit user_session_path
        find('#guest-login-button').click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ゲストユーザーとしてログインしました。'
        expect(current_path).to eq root_path
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }

    context 'ログアウトボタンをクリックする' do
      it '正常にログアウトできる' do
        visit root_path
        find('.navbar-toggler').click
        click_link 'ログアウト'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ログアウトしました。'
        expect(current_path).to eq user_session_path
      end
    end
  end
end