module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    if notification.event_id.present?
      @visiter_comment = notification.event_comment_id
    else
      @visiter_comment = notification.task_comment_id
    end
    #notification.actionがfollowかlikeかcommentか
    case notification.action
      when "follow" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"があなたをフォローしました"
      when "favorite" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:event_path(notification.event_id), style:"font-weight: bold;")+"にいいねしました"
      when "like" then
        tag.a(notification.visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:task_path(notification.task_id), style:"font-weight: bold;")+"にいいねしました"
      when "event_comment" then
        @event_comment = EventComment.find_by(id: @visiter_comment)
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:event_path(notification.event_id), style:"font-weight: bold;")+"にコメントしました"
      when "task_comment" then
        @task_comment = TaskComment.find_by(id: @visiter_comment)
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:task_path(notification.task_id), style:"font-weight: bold;")+"にコメントしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
