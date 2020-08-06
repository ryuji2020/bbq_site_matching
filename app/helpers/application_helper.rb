module ApplicationHelper
  def full_title(page_title)
    base_title = "Mad Outdoor!"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
end
