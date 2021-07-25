require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }
  let!(:task) { create(:task, user: user) }
  let!(:other_task) { create(:task, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'search buttonを押すと、検索結果画面に遷移する' do
        search_button = find_all('button')[2].native
        search_button = search_button.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_button search_button
        is_expected.to eq '/search'
      end
      it 'Bellアイコンを押すと、通知一覧画面を表示する' do
        bells_link = find_all('a')[3].native.inner_text
        bells_link = bells_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link bells_link
        is_expected.to eq 'notifications'
      end
      it 'Usersを押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[4].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'EventCalendarを押すと、イベント一覧画面に遷移する' do
        event_calendar_link = find_all('a')[5].native.inner_text
        event_calendar_link = event_calendar_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link event_calendar_link
        is_expected.to eq '/events'
      end
      it 'TaskCalendarを押すと、タスク一覧画面に遷移する' do
        task_calendar_link = find_all('a')[6].native.inner_text
        task_calendar_link = task_calendar_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link task_calendar_link
        is_expected.to eq '/tasks'
      end
      it 'MyPageを押すと、マイページ画面に遷移する' do
        mypage_link = find_all('a')[7].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/users/i'
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
      it 'イベントの日付とカレンダーの日付がそれぞれ正しい' do
        expect(start_date_datetime).to match(datetime)
        expect(end_date_datetime).to match(datetime)
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link event.title, href: event_path(event)
        expect(page).to have_link other_event.title, href: event_path(other_event)
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
      it '作成！ボタンが表示される' do
        expect(page).to have_button '作成！'
      end
    end

    # describe 'タスク一覧画面のテスト' do
    # before do
    #   visit tasks_path
    # end

    # context '表示内容の確認' do
    #   it 'URLが正しい' do
    #     expect(current_path).to eq '/tasks'
    #   end
    #   it 'タスクの日付とカレンダーの日付がそれぞれ正しい' do
    #     expect(start_date_datetime).to match(datetime)
    #     expect(end_date_datetime).to match(datetime)
    #   end
    #   it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
    #     expect(page).to have_link task.title, href: task_path(task)
    #     expect(page).to have_link other_task.title, href: task_path(other_task)
    #   end
    # end

    context '投稿成功のテスト' do
      before do
        fill_in 'book[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'book[body]', with: Faker::Lorem.characters(number: 20)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '作成！' }.to change(user.events, :count).by(1)
      end
      it 'リダイレクト先が、イベント一覧画面になっている' do
        click_button '作成！'
        expect(current_path).to eq '/events/'
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit event_path(event)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/events/' + event.id.to_s
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
        expect(page).to have_link 'icon', href: edit_event_path(event)
      end
      it '投稿のマップリンクが表示される' do
        expect(page).to have_link 'icon', href: event_maps_path(event_id: event.id)
      end
      it 'いいねが表示される: 自身の投稿の場合ボタンではない' do
        if event.user == current_user
          expect(page).to should_not have_button event.favorites.count
        else
          expect(page).to have_button event.favorites.count
        end
      end
      it 'コメント件数が表示される' do
        expect(page).to have_content event_comments.count
      end
      it '開始時刻が表示される' do
        expect(page).to have_content event.start_date
      end
      it '投稿の概要が表示される' do
        expect(page).to have_content event.end_date
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
        if event_comment.user == current_user
          expect(page).to have_link 'icon', href: event_event_comment_path(event.id, event_comment)
        end
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link 'fas fa-edit'
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
        expect(page).to have_field 'book[title]', with: book.title
      end
      it 'opinion編集フォームが表示される' do
        expect(page).to have_field 'book[body]', with: book.body
      end
      it 'Update Bookボタンが表示される' do
        expect(page).to have_button 'Update Book'
      end
      it 'Showリンクが表示される' do
        expect(page).to have_link 'Show', href: book_path(book)
      end
      it 'Backリンクが表示される' do
        expect(page).to have_link 'Back', href: books_path
      end
    end

    context '編集成功のテスト' do
      before do
        @book_old_title = book.title
        @book_old_body = book.body
        fill_in 'book[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'book[body]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update Book'
      end

      it 'titleが正しく更新される' do
        expect(book.reload.title).not_to eq @book_old_title
      end
      it 'bodyが正しく更新される' do
        expect(book.reload.body).not_to eq @book_old_body
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/books/' + book.id.to_s
        expect(page).to have_content 'Book detail'
      end
    end
    context '削除リンクのテスト' do
      before do
        click_link 'Destroy'
      end

      it '正しく削除される' do
        expect(Book.where(id: book.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/books'
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
      it '自分と他人の画像が表示される: fallbackの画像がサイドバーの1つ＋一覧(2人)の2つの計3つ存在する' do
        expect(all('img').size).to eq(3)
      end
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it '自分と他人のshowリンクがそれぞれ表示される' do
        expect(page).to have_link 'Show', href: user_path(user)
        expect(page).to have_link 'Show', href: user_path(other_user)
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '「New book」と表示される' do
        expect(page).to have_content 'New book'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'book[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('book[title]').text).to be_blank
      end
      it 'opinionフォームが表示される' do
        expect(page).to have_field 'book[body]'
      end
      it 'opinionフォームに値が入っていない' do
        expect(find_field('book[body]').text).to be_blank
      end
      it 'Create Bookボタンが表示される' do
        expect(page).to have_button 'Create Book'
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
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
        expect(page).to have_link book.title, href: book_path(book)
      end
      it '投稿一覧に自分の投稿のopinionが表示される' do
        expect(page).to have_content book.body
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_book.title
        expect(page).not_to have_content other_book.body
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      it '「New book」と表示される' do
        expect(page).to have_content 'New book'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'book[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('book[title]').text).to be_blank
      end
      it 'opinionフォームが表示される' do
        expect(page).to have_field 'book[body]'
      end
      it 'opinionフォームに値が入っていない' do
        expect(find_field('book[body]').text).to be_blank
      end
      it 'Create Bookボタンが表示される' do
        expect(page).to have_button 'Create Book'
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
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される' do
        expect(page).to have_button 'Update User'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update User'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end