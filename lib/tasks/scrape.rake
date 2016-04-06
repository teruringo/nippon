require 'open-uri'
require 'mechanize'

namespace :scrape do
  desc '日本代表の試合を日本代表DBから取得'
  task :scrape_match_data => :environment do
    
    agent = Mechanize.new
    
    #繰り返しで変数に入れる処理
    for n in 1964..1965 do
    # for n in 1923..1925 do # 1923～1925年のページ
      page = agent.get("http://www.japannationalfootballteam.com/#{n}")
      
      next unless page.search('title').inner_text.include?("サッカー日本代表データベース")
      
      elements = Hash.new( {} ) # 多重ハッシュ用の初期化
      # elements[:title] = page.search('title').inner_text
      elements[:date] = page.search('table.results tr + tr td.date')
      elements[:opponent] = page.search('table.results tr + tr td.opp')
      elements[:ha] = page.search('table.results tr + tr td.ha')
      elements[:score] = page.search('table.results tr + tr td.score')
      elements[:venue] = page.search('table.results tr + tr td.venue')
      elements[:tournament] = page.search('table.results tr + tr td.comp')
      
      p elements[:date]
      p elements[:date].inner_text
      p elements[:date][0]
      p elements[:date][1]
      p elements[:date][0].inner_text
      
      p elements[:test] = page.search('table.results td.date')
      
      elements[:date].count.times do |m|
        # ホームアンドアウェー
        if elements[:ha][m] == "H"
          elements[:away_team][m] = elements[:opponent][m]
          elements[:home_team][m] = "日本代表"
        else
          elements[:home_team][m] = elements[:opponent][m]
          elements[:away_team][m] = "日本代表"
        end
        p "2行目"+elements[:ha][m]
        p elements[m]
        p "home_team→" + elements[:home_team][m]
        p "away_team→" + elements[:away_team][m]
        p "ha→" + elements[:ha][m]
        p "opponent→" + elements[:opponent][m]
        # Game.create!()
        #2変数を順番に指定
        # puts elements[:date][m].inner_text + elements[:opponent][m].inner_text
      end
    end
  end
end
