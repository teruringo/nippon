module ApplicationHelper
  # titleタグにサイト名を入れる
  def full_title(page_title = ' ')
    base_title = "日本代表の試合"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
