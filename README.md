# DeskVista.

### サービスURL
https://desk-vista-fb6c4daa8df6.herokuapp.com/

## サービス概要

---
#### DeskVista.は自身のデスク環境を投稿して他人と共有する事ができるサービスです。

## サービスコンセプト

- このアプリを作ろうと思ったきっかけ  
  私は、キーボードやマウスなどの周辺機器を聞くのが好きで、YoutubeやWebサイトなど他の人のPC環境を拝見して、自分のPC環境を整えるのにしかし、色々なウェブサイトを巡回しているため、情報収集に手間がかかっていました。とこのアプリケーションを思いつきました。

- サービスについてとどんなサービスにしていきたいか
  このアプリは、自分のPC環境を写真や説明とともに投稿して、他のユーザーと共有するためのアプリです。
  。使いやすいUI設計として、ユーザーが簡単に利用できるようなアプリケーションを目指しています。 

## 主な機能

---

- ユーザー登録前・ログイン前の機能
    - 投稿閲覧機能）
    - ログイン・アカウント登録機能
    - Googleアカウントによるアカウント作成及びログイン機能
    - ゲストユーザー機能
    - パスワードリセット機能

- ログイン後の機能
  - デスク環境投稿機能
    - デスクの写真（最大８枚）、説明、タグを入力して投稿
    - 使用しているアイテムを楽天APIを用いて検索し自身の投稿に登録できる機能
  - いいね機能
  - ブックマーク機能
    - ブックマークした投稿を一覧で確認できる
  - コメント機能
  - マイページ機能
    - 自身のユーザーネーム、プロフィール画像を変更できる
    - ユーザー退会機能

## 使用技術

---

### バックエンド

- Ruby (3.2.0)
- Ruby on Rails (7.0.8)
- PostgreSQL

### Gem

- device（ユーザー認証）
- active_storage_validations（画像アップロード検証）
- mini_magick（画像加工）
- acts-as-taggable-on（タグ）
- kaminari（ページネーション）
- rakuten_web_service (楽天API)
- high_voltage (利用規約、プライバシポリシーページ作成)

### インフラ

- Heroku

### API

- Rakuten Web Service

## ER図

---

https://drive.google.com/file/d/1PCZzF7aetKJ_zsyqK_KcA2qTOWTn4W72/view?usp=sharing

## 画面遷移図

---

https://www.figma.com/file/lTZ6R61oXH0SHq2PxyiKtu/DeskVista.%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB?type=design&node-id=0%3A1&mode=design&t=ptFGLOvyNQpDZiGb-1

