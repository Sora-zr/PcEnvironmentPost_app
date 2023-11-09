require 'rails_helper'

RSpec.describe Post, type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'ログイン前' do

    describe 'ページの遷移確認' do

      context '投稿一覧画面にアクセスする' do
        it 'アクセスが失敗する' do
          visit posts_path
          expect(page).to have_content 'アカウント登録もしくはログインしてください。'
          expect(current_path).to eq user_session_path
        end
      end

      context '投稿詳細画面にアクセスする' do
        it 'アクセスが失敗する' do
          visit post_path(post)
          expect(page).to have_content 'アカウント登録もしくはログインしてください。'
          expect(current_path).to eq user_session_path
        end
      end

      context '投稿新規作成画面にアクセスする' do
        it 'アクセスが失敗する' do
          visit new_post_path
          expect(page).to have_content 'アカウント登録もしくはログインしてください。'
          expect(current_path).to eq user_session_path
        end
      end

      context '投稿編集画面にアクセスする' do
        it 'アクセスが失敗する' do
          visit edit_post_path(post)
          expect(page).to have_content 'アカウント登録もしくはログインしてください。'
          expect(current_path).to eq user_session_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { sign_in user }

    describe '投稿を新規作成する' do

      context 'フォームの入力値が正常' do
        it '投稿の作成が成功する' do
          visit new_post_path
          attach_file('post_images', Rails.root.join('spec/fixtures/test_image.jpg'))
          fill_in '説明', with: 'Test Description'
          fill_in 'タグ', with: 'Test_tag1, Test_tag2, Test_tag3'
          click_button '登録する'
          expect(page).to have_content '投稿が完了しました。'
          expect(current_path).to eq posts_path
        end
      end
    end

    describe '投稿を削除する' do
      let!(:post) { create(:post, user: user) }

      it '投稿の削除が成功する（一覧画面から）' do
        visit posts_path
        find('#delete-btn').click
        expect(page.accept_confirm).to eq '本当に削除しますか？'
        expect(page).to have_content '投稿を削除しました。'
        expect(current_path).to eq posts_path
      end

      it '投稿の削除が成功する（詳細画面から）' do
        visit post_path(post)
        find('#delete-btn').click
        expect(page.accept_confirm).to eq '本当に削除しますか？'
        expect(page).to have_content '投稿を削除しました。'
        expect(current_path).to eq posts_path
      end
    end

  end

end