require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }
  let!(:task) { create(:task, user: user) }
  let!(:other_task) { create(:task, user: other_user) }
  let!(:event_comment) { create(:event_comment, user: user, event: event) }
  let!(:task_comment) { create(:task_comment, user: user, task: task) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'search buttonを押すと、検索結果画面に遷移する' do
        click_button 'button'
        is_expected.to eq '/search'
      end
      it 'Usersを押すと、ユーザ一覧画面に遷移する' do
        click_link 'Users'
        is_expected.to eq '/users'
      end
      it 'EventCalendarを押すと、イベント一覧画面に遷移する' do
        click_link 'Event Calendar'
        is_expected.to eq '/events'
      end
      it 'TaskCalendarを押すと、タスク一覧画面に遷移する' do
        click_link 'Task Calendar'
        is_expected.to eq '/tasks'
      end
      it 'MyPageを押すと、マイページ画面に遷移する' do
        click_link 'My Page'
        is_expected.to eq '/users/' + user.id.to_s
      end
    end
  end

  describe 'イベント一覧画面のテスト' do
    before do
      visit events_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events'
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link event.title, href: event_url(event, format: :html)
        expect(page).to have_link other_event.title, href: event_url(other_event, format: :html)
      end
    end

    context "投稿フォームの確認" do
      it "「新規作成」と表示される" do
        expect(page).to have_content '新規作成'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'event[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('event[title]').text).to be_blank
      end
      it '概要フォームが表示される' do
        expect(page).to have_field 'event[body]'
      end
      it '概要フォームに値が入っていない' do
        expect(find_field('event[body]').text).to be_blank
      end
      it '場所フォームが表示される' do
        expect(page).to have_field 'event[location]'
      end
      it '場所フォームに値が入っていない' do
        expect(find_field('event[location]').text).to be_blank
      end
      it '開始フォームが表示される' do
        expect(page).to have_field 'event[start_date]'
      end
      it '開始フォームに値が入っていない' do
        expect(find_field('event[start_date]').text).to be_blank
      end
      it '終了フォームが表示される' do
        expect(page).to have_field 'event[end_date]'
      end
      it '終了フォームに値が入っていない' do
        expect(find_field('event[end_date]').text).to be_blank
      end
      it '作成！ボタンが表示される' do
        expect(page).to have_button '作成！'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'event[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'event[body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'event[location]', with: Faker::Nation.capital_city
        fill_in 'event[start_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        fill_in 'event[end_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '作成！' }.to change(user.events, :count).by(1)
      end
      it 'リダイレクト先が、イベント一覧画面になっている' do
        click_button '作成！'
        expect(current_path).to eq '/events'
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit event_url(event, format: :html)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '.html'
      end
      it 'ユーザ画像のリンク先が正しい' do
        expect(page).to have_link event.user.profile_image_id, href: user_path(event.user)
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content event.title
      end
      it '投稿の概要が表示される' do
        expect(page).to have_content event.body
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link, href: edit_event_path(event)
      end
      it '投稿のマップリンクが表示される' do
        expect(page).to have_link, href: event_maps_path(event_id: event.id)
      end
      it 'いいねが表示される' do
          expect(page).not_to have_link event.favorites.count
      end
      it 'コメント件数が表示される' do
        expect(page).to have_content 'コメント件数'
      end
      it '開始時刻が表示される' do
        expect(page).to have_content event.start_date.strftime("%Y/%m/%d %H:%M")
      end
      it '終了時刻が表示される' do
        expect(page).to have_content event.end_date.strftime("%Y/%m/%d %H:%M")
      end
      it 'コメント一覧が表示される: コメントしたユーザー名が表示される' do
        expect(page).to have_content event_comment.user.name
      end
      it 'コメント一覧が表示される: コメントした内容が表示される' do
        expect(page).to have_content event_comment.comment
      end
      it 'コメント一覧が表示される: コメントした日時が表示される' do
        expect(page).to have_content event_comment.created_at.strftime("%m/%d %H:%M")
      end
      it 'コメント一覧が表示される: コメント削除ボタンが表示される' do
          expect(page).to have_link, href: event_event_comment_path(event.id, event_comment)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link href: edit_event_path(event)
        expect(current_path).to eq '/events/' + event.id.to_s + '/edit'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_event_path(event)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/edit'
      end
      it '「event edit」と表示される' do
        expect(page).to have_content 'event edit'
      end
      it 'title編集フォームが表示される' do
        expect(page).to have_field 'event[title]', with: event.title
      end
      it '概要編集フォームが表示される' do
        expect(page).to have_field 'event[body]', with: event.body
      end
      it '場所編集フォームが表示される' do
        expect(page).to have_field 'event[location]', with: event.location
      end
      it '開始編集フォームが表示される' do
        expect(page).to have_field 'event[start_date]'
      end
      it '終了編集フォームが表示される' do
        expect(page).to have_field 'event[end_date]'
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '更新'
      end
      it '削除リンクが表示される' do
        expect(page).to have_link '削除', href: event_path(event)
      end
    end

    context '編集成功のテスト' do
      before do
        @event_old_title = event.title
        @event_old_body = event.body
        @event_old_location = event.location
        @event_old_start_date = event.start_date
        @event_old_end_date = event.end_date
        fill_in 'event[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'event[body]', with: Faker::Lorem.characters(number: 19)
        fill_in 'event[location]', with: Faker::Nation.capital_city
        fill_in 'event[start_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        fill_in 'event[end_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        click_button '更新'
      end

      it 'titleが正しく更新される' do
        expect(event.reload.title).not_to eq @event_old_title
      end
      it 'bodyが正しく更新される' do
        expect(event.reload.body).not_to eq @event_old_body
      end
      it 'locationが正しく更新される' do
        expect(event.reload.location).not_to eq @event_old_location
      end
      it 'start_dateが正しく更新される' do
        expect(event.reload.start_date).not_to eq @event_old_start_date
      end
      it 'end_dateが正しく更新される' do
        expect(event.reload.end_date).not_to eq @event_old_end_date
      end
      it 'リダイレクト先が、更新した投稿の一覧画面になっている' do
        expect(current_path).to eq '/events'
      end
    end
    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Event.where(id: event.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/events'
      end
    end
  end

  describe 'タスク一覧画面のテスト' do
    before do
      visit tasks_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/tasks'
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link task.title, href: task_url(task, format: :html)
        expect(page).to have_link other_task.title, href: task_url(other_task, format: :html)
      end
    end

    context "投稿フォームの確認" do
      it "「新規タスク」と表示される" do
        expect(page).to have_content '新規タスク'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'task[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('task[title]').text).to be_blank
      end
      it '詳細フォームが表示される' do
        expect(page).to have_field 'task[body]'
      end
      it '詳細フォームに値が入っていない' do
        expect(find_field('task[body]').text).to be_blank
      end
      it '開始フォームが表示される' do
        expect(page).to have_field 'task[start_date]'
      end
      it '開始フォームに値が入っていない' do
        expect(find_field('task[start_date]').text).to be_blank
      end
      it '終了フォームが表示される' do
        expect(page).to have_field 'task[end_date]'
      end
      it '終了フォームに値が入っていない' do
        expect(find_field('task[end_date]').text).to be_blank
      end
      it '登録！ボタンが表示される' do
        expect(page).to have_button '登録！'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'task[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'task[body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'task[start_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        fill_in 'task[end_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '登録！' }.to change(user.tasks, :count).by(1)
      end
      it 'リダイレクト先が、タスク一覧画面になっている' do
        click_button '登録！'
        expect(current_path).to eq '/tasks'
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit task_url(task, format: :html)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/tasks/' + task.id.to_s + '.html'
      end
      it 'ユーザ画像のリンク先が正しい' do
        expect(page).to have_link task.user.profile_image_id, href: user_path(task.user)
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content task.title
      end
      it '投稿の概要が表示される' do
        expect(page).to have_content task.body
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link, href: edit_task_path(task)
      end
      it '実施状況のチェックボックスが表示される' do
        expect(page).to have_field('pratical_{}')
      end
      it 'チェックボックスに値が入っていない' do
        expect(page).to have_unchecked_field('pratical_{}')
      end
      it 'いいねが表示される' do
          expect(page).not_to have_link task.likes.count
      end
      it 'コメント件数が表示される' do
        expect(page).to have_content 'コメント件数'
      end
      it '開始時刻が表示される' do
        expect(page).to have_content task.start_date.strftime("%Y,%m/%d %H:%M")
      end
      it '終了時刻が表示される' do
        expect(page).to have_content task.end_date.strftime("%Y,%m/%d %H:%M")
      end
      it 'コメント一覧が表示される: コメントしたユーザー名が表示される' do
        expect(page).to have_content task_comment.user.name
      end
      it 'コメント一覧が表示される: コメントした内容が表示される' do
        expect(page).to have_content task_comment.comment
      end
      it 'コメント一覧が表示される: コメントした日時が表示される' do
        expect(page).to have_content task_comment.created_at.strftime("%m/%d %H:%M")
      end
      it 'コメント一覧が表示される: コメント削除ボタンが表示される' do
          expect(page).to have_link, href: task_task_comment_path(task.id, task_comment)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link href: edit_task_path(task)
        expect(current_path).to eq '/tasks/' + task.id.to_s + '/edit'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_task_path(task)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/tasks/' + task.id.to_s + '/edit'
      end
      it '「task edit」と表示される' do
        expect(page).to have_content 'task edit'
      end
      it 'title編集フォームが表示される' do
        expect(page).to have_field 'task[title]', with: task.title
      end
      it '概要編集フォームが表示される' do
        expect(page).to have_field 'task[body]', with: task.body
      end
      it '開始編集フォームが表示される' do
        expect(page).to have_field 'task[start_date]'
      end
      it '終了編集フォームが表示される' do
        expect(page).to have_field 'task[end_date]'
      end
      it '更新リンクが表示される' do
        expect(page).to have_button '更新'
      end
      it '削除リンクが表示される' do
        expect(page).to have_link '削除', href: task_path(task)
      end
    end

    context '編集成功のテスト' do
      before do
        @task_old_title = task.title
        @task_old_body = task.body
        @task_old_start_date = task.start_date
        @task_old_end_date = task.end_date
        fill_in 'task[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'task[body]', with: Faker::Lorem.characters(number: 19)
        fill_in 'task[start_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        fill_in 'task[end_date]', with: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        click_button '更新'
      end

      it 'titleが正しく更新される' do
        expect(task.reload.title).not_to eq @task_old_title
      end
      it 'bodyが正しく更新される' do
        expect(task.reload.body).not_to eq @task_old_body
      end
      it 'start_dateが正しく更新される' do
        expect(task.reload.start_date).not_to eq @task_old_start_date
      end
      it 'end_dateが正しく更新される' do
        expect(task.reload.end_date).not_to eq @task_old_end_date
      end
      it 'リダイレクト先が、更新した投稿の一覧画面になっている' do
        expect(current_path).to eq '/tasks'
      end
    end
    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Task.where(id: task.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/tasks'
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分と他人の画像が表示される' do
        expect(all('img').size).to eq(2)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人の自己紹介がそれぞれ表示される' do
        expect(page).to have_content user.introduction
        expect(page).to have_content other_user.introduction
      end
      it '自分と他人の名前リンクがそれぞれ表示される' do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link other_user.name, href: user_path(other_user)
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it 'ユーザ画像の表示が正しい' do
        expect(all('img').size).to eq(1)
      end
      it 'ユーザー名が表示される' do
        expect(page).to have_content user.name
      end
      it 'メールアドレスが表示される' do
        expect(page).to have_content user.email
      end
      it '自己紹介が表示される' do
        expect(page).to have_content user.introduction
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
        expect(page).to have_link event.title, href: event_path(event)
        expect(page).to have_link task.title, href: task_path(task)
      end
      it '投稿一覧に自分の投稿の概要が表示される' do
        expect(page).to have_content event.body
        expect(page).to have_content task.body
      end
      it '投稿一覧に自分の投稿の場所が表示される' do
        expect(page).to have_content event.location
      end
      it '投稿一覧に自分の投稿の実施状況が表示される' do
        expect(page).to have_content task.pratical
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_event.title
        expect(page).not_to have_content other_task.title
        expect(page).not_to have_content other_event.body
        expect(page).not_to have_content other_task.body
        expect(page).not_to have_content other_event.location
        expect(page).not_to have_content other_task.pratical
      end
      it "フォロー、フォロワーのリンクが表示され、リンクが正しい" do
        expect(page).to have_link "フォロー#{user.followings.count}", href: user_followings_path(user)
        expect(page).to have_link "フォロワー#{user.followers.count}", href: user_followers_path(user)
      end
      it 'ユーザーの編集リンクが表示される' do
        expect(page).to have_link 'icon', href: edit_user_path(user)
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it "メールアドレス編集フォームに自分のメールアドレスが表示される" do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button '保存'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_introduction = user.introduction
        fill_in 'user[name]', with: Faker::Name.last_name(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button '保存'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
  describe 'マップ一覧画面のテスト' do
    before do
      visit event_maps_path(event_id: event.id)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s + '/maps'
      end
      it '「gmap」と表示される' do
        expect(page).to have_content 'gmap'
      end
      it '地名編集フォームに登録した地名が表示される' do
        expect(page).to have_field 'event[location]', with: event.location
      end
      it '地図表示ボタンが表示される' do
        expect(page).to have_button '地図表示'
      end
    end

    context '更新成功のテスト' do
      before do
        @event_old_location = event.location
        fill_in 'event[location]', with: Faker::Nation.capital_city
        click_button '地図表示'
      end

      it 'locationが正しく更新される' do
        expect(event.reload.location).not_to eq @event_old_location
      end
    end
  end
  describe 'ユーザ検索結果一覧画面のテスト' do
    before do
      visit search_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/search/?utf8=✓&word=#{params[:word]}&range=User&button="
      end
      it '自分と他人の画像が表示される' do
        expect(all('img').size).to eq(2)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人の自己紹介がそれぞれ表示される' do
        expect(page).to have_content user.introduction
        expect(page).to have_content other_user.introduction
      end
      it '自分と他人の名前リンクがそれぞれ表示される' do
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_link other_user.name, href: user_path(other_user)
      end
    end
  end
  describe 'イベント検索結果一覧画面のテスト' do
    before do
      visit search_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/search/?utf8=✓&word=#{params[:word]}&range=Event&button="
      end
      it '自分と他人の画像が表示される' do
        expect(all('img').size).to eq(2)
      end
      it 'タイトルが表示される' do
        expect(page).to have_content event.title
      end
      it '概要が表示される' do
        expect(page).to have_content event.body
      end
      it '場所が表示される' do
        expect(page).to have_content event.location
      end
      it '開始時刻がそれぞれ表示される' do
        expect(page).to have_content event.start_date
      end
      it '終了時刻がそれぞれ表示される' do
        expect(page).to have_content event.end_date
      end
      it 'タイトルのリンクが表示される' do
        expect(page).to have_link event.title, href: event_path(event)
      end
    end
  end
  describe 'タスク検索結果一覧画面のテスト' do
    before do
      visit search_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/search/?utf8=✓&word=#{params[:word]}&range=Task&button="
      end
      it '自分と他人の画像が表示される' do
        expect(all('img').size).to eq(2)
      end
      it 'タイトルが表示される' do
        expect(page).to have_content task.title
      end
      it '概要が表示される' do
        expect(page).to have_content task.body
      end
      it '開始時刻がそれぞれ表示される' do
        expect(page).to have_content task.start_date
      end
      it '終了時刻がそれぞれ表示される' do
        expect(page).to have_content task.end_date
      end
      it 'タイトルのリンクが表示される' do
        expect(page).to have_link task.title, href: task_path(task)
      end
    end
  end
end