module ApplicationHelper
  # titleタグにサイト名を入れる
  def full_title(page_title = ' ')
    base_title = Rails.env.development? ?
      "【開発】日本代表の試合" : "日本代表の試合"
    page_title.empty? ?
      base_title : page_title + " | " + base_title
  end
end
