require "rails_helper"

describe '[STEP3] 仕上げのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }
  let!(:task) { create(:task, user: user) }
  let!(:other_task) { create(:task, user: other_user) }

  describe '処理失敗時のテスト' do
    context 'ユーザ新規登録失敗: nameを11文字にする' do
      before do
        visit new_user_registration_path
        @name = Faker::Name.last_name(number: 11)
        @email = 'a' + user.email # 確実にuser, other_userと違う文字列にするため
        fill_in 'user[name]', with: @name
        fill_in 'user[email]', with: @email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button '登録' }.not_to change(User.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button '登録'
        expect(page).to have_content '登録'
        expect(page).to have_field 'user[name]', with: @name
        expect(page).to have_field 'user[email]', with: @email
      end
      it 'バリデーションエラーが表示される' do
        click_button '登録'
        expect(page).to have_content "is too long (maximum is 10 characters)"
      end
    end

    context 'ユーザのプロフィール情報編集失敗: nameを11文字にする' do
      before do
        @user_old_name = user.name
        @name = Faker::Name.last_name(number: 11)
        visit new_user_session_path
        fill_in 'user[name]', with: @user_old_name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_user_path(user)
        fill_in 'user[name]', with: @name
        click_button '保存'
      end

      it '更新されない' do
        expect(user.reload.name).to eq @user_old_name
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'user[name]', with: @name
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content "is too long (maximum is 10 characters)"
      end
    end

    context 'イベント投稿データの新規投稿失敗: 投稿一覧画面から行い、titleを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit events_path
        @body = Faker::Lorem.characters(number: 19)
        @location = Faker::Nation.capital_city
        @start_date = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        @end_date = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        fill_in 'event[body]', with: @body
        fill_in 'event[location]', with: @location
        fill_in 'event[start_date]', with: @start_date
        fill_in 'event[end_date]', with: @end_date
      end

      it '投稿が保存されない' do
        expect { click_button '作成！' }.not_to change(Event.all, :count)
      end
      it '投稿一覧画面を表示している' do
        click_button '作成！'
        expect(current_path).to eq '/events'
        expect(page).to have_content event.body
        expect(page).to have_content other_event.body
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('event[title]').text).to be_blank
        expect(page).to have_field 'event[body]', with: @body
      end
      it 'バリデーションエラーが表示される' do
        click_button '作成！'
        expect(page).to have_content "can't be blank"
      end
    end

    context 'イベント投稿データの更新失敗: titleを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_event_path(event)
        @event_old_title = event.title
        fill_in 'event[title]', with: ''
        click_button '保存'
      end

      it '投稿が更新されない' do
        expect(event.reload.title).to eq @event_old_title
      end
      it '投稿編集画面を表示しており、フォームの内容が正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s
        expect(find_field('event[title]').text).to be_blank
        expect(page).to have_field 'event[body]', with: event.body
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'error'
      end
    end
    context 'タスク投稿データの新規投稿失敗: 投稿一覧画面から行い、titleを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit tasks_path
        @body = Faker::Lorem.characters(number: 19)
        @start_date = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        @end_date = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        fill_in 'task[body]', with: @body
        fill_in 'task[start_date]', with: @start_date
        fill_in 'task[end_date]', with: @end_date
      end

      it '投稿が保存されない' do
        expect { click_button '登録！' }.not_to change(Task.all, :count)
      end
      it '投稿一覧画面を表示している' do
        click_button '登録！'
        expect(current_path).to eq '/tasks'
        expect(page).to have_content task.body
        expect(page).to have_content other_task.body
      end
      it '新規投稿フォームの内容が正しい' do
        expect(find_field('task[title]').text).to be_blank
        expect(page).to have_field 'task[body]', with: @body
      end
      it 'バリデーションエラーが表示される' do
        click_button '登録！'
        expect(page).to have_content "can't be blank"
      end
    end

    context 'タスク投稿データの更新失敗: titleを空にする' do
      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        visit edit_task_path(task)
        @task_old_title = task.title
        fill_in 'task[title]', with: ''
        click_button '保存'
      end

      it '投稿が更新されない' do
        expect(task.reload.title).to eq @task_old_title
      end
      it '投稿編集画面を表示しており、フォームの内容が正しい' do
        expect(current_path).to eq '/tasks/' + task.id.to_s
        expect(find_field('task[title]').text).to be_blank
        expect(page).to have_field 'task[body]', with: task.body
      end
      it 'エラーメッセージが表示される' do
        expect(page).to have_content 'error'
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ一覧画面' do
      visit users_path
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ情報編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'イベント投稿一覧画面' do
      visit events_path
      is_expected.to eq '/users/sign_in'
    end
    it 'イベント投稿詳細画面' do
      visit event_path(event)
      is_expected.to eq '/users/sign_in'
    end
    it 'イベント投稿編集画面' do
      visit edit_event_path(event)
      is_expected.to eq '/users/sign_in'
    end
    it 'タスク投稿一覧画面' do
      visit tasks_path
      is_expected.to eq '/users/sign_in'
    end
    it 'タスク投稿詳細画面' do
      visit task_path(task)
      is_expected.to eq '/users/sign_in'
    end
    it 'タスク投稿編集画面' do
      visit edit_task_path(task)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    describe '他人のイベント投稿詳細画面のテスト' do
      before do
        visit event_path(other_event)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/events/' + other_event.id.to_s
        end
        it 'ユーザ画像・名前のリンク先が正しい' do
          expect(page).to have_link other_event.user.name, href: user_path(other_event.user)
        end
        it '投稿のtitleが表示される' do
          expect(page).to have_content other_event.title
        end
        it '投稿の概要が表示される' do
          expect(page).to have_content other_event.body
        end
        it '投稿の編集リンクが表示されない' do
          expect(page).not_to have_link 'fas fa-edit'
        end
      end
    end
    describe '他人のタスク投稿詳細画面のテスト' do
      before do
        visit task_path(other_task)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/tasks/' + other_task.id.to_s
        end
        it 'ユーザ画像・名前のリンク先が正しい' do
          expect(page).to have_link other_task.user.name, href: user_path(other_task.user)
        end
        it '投稿のtitleが表示される' do
          expect(page).to have_content other_task.title
        end
        it '投稿の詳細が表示される' do
          expect(page).to have_content other_task.body
        end
        it '投稿の編集リンクが表示されない' do
          expect(page).not_to have_link 'fas fa-edit'
        end
      end
    end

    context '他人の投稿編集画面' do
      it '遷移できず、投稿一覧画面にリダイレクトされる' do
        visit edit_event_path(other_event)
        expect(current_path).to eq '/events'
        visit edit_task_path(other_task)
        expect(current_path).to eq '/tasks'
      end
    end

    describe '他人のユーザ詳細画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + other_user.id.to_s
        end
        it '投稿一覧のユーザ画像のリンク先が正しい' do
          expect(page).to have_link '', href: user_path(other_user)
        end
        it '投稿一覧に他人の投稿のtitleが表示され、リンクが正しい' do
          expect(page).to have_link other_event.title, href: event_path(other_event)
          expect(page).to have_link other_task.title, href: task_path(other_task)
        end
        it '投稿一覧に他人の投稿の概要・詳細が表示される' do
          expect(page).to have_content other_event.body
          expect(page).to have_content other_task.body
        end
        it '自分の投稿は表示されない' do
          expect(page).not_to have_content event.title
          expect(page).not_to have_content event.body
          expect(page).not_to have_content task.title
          expect(page).not_to have_content task.body
        end
      end
    end

    context '他人のユーザ情報編集画面' do
      it '遷移できず、自分のユーザ詳細画面にリダイレクトされる' do
        visit edit_user_path(other_user)
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe 'アイコンのテスト' do
    context 'ヘッダー: ログインしている場合' do
      subject { page }

      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'searchリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas fa-search'
      end
      it 'Notificationリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas fa-bell'
      end
      it 'Usersリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas fa-users'
      end
      it 'EventCalendarリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas fa-calendar-alt'
      end
      it 'TaskCalendarリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas fa-calendar-check'
      end
      it 'MyPageリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas fa-house-user'
      end
    end

    context 'ユーザー編集画面' do
      subject { page }

      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ユーザ編集画面でエディットアイコンが表示される' do
        visit user_path(current_path)
        is_expected.to have_selector '.fas fa-user-edit'
      end
    end
    context 'イベント詳細画面' do
      subject { page }

      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'イベント詳細画面でエディットアイコンが表示される' do
        visit event_path(event.current_user)
        is_expected.to have_selector '.fas fa-edit'
      end
      it "イベント詳細画面でマップアイコンが表示される" do
        visit event_path(event)
        is_expected.to have_selector '.fas fa-map-market-alt'
      end
    end
    context 'タスク詳細画面' do
      subject { page }

      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'タスク詳細画面でエディットアイコンが表示される' do
        visit task_path(task.current_user)
        is_expected.to have_selector '.fas fa-edit'
      end
    end
  end
end