require 'open-uri'
require 'mechanize'

namespace :scrape do
  desc '日本代表の試合を日本代表DBから取得'
  task :scrape_match_data => :environment do
    
    agent = Mechanize.new
    
    #繰り返しで変数に入れる処理
    for n in 1964..1965 do
    # for n in 1923..1925 do # 1923～1925年のページ
      @page = agent.get("http://www.japannationalfootballteam.com/#{n}")
      
      next unless @page.search('title').inner_text.include?("サッカー日本代表データベース")
      
      elements = Hash.new( {} ) # 多重ハッシュ用の初期化
      insert = Hash.new( {} ) # 多重ハッシュ用の初期化
      
      @page.search('table.results td.date').count.times do |i|
        # データ取得
        elements[:date] =       @page.search('table.results td.date'  )[i].inner_text
        elements[:opponent] =   @page.search('table.results td.opp a' )[i].inner_text
        elements[:ha] =         @page.search('table.results td.ha'    )[i].inner_text
        elements[:score] =      @page.search('table.results td.score' )[i].inner_text
        elements[:venue] =      @page.search('table.results td.venue' )[i].inner_text
        elements[:tournament] = @page.search('table.results td.comp'  )[i].inner_text
        
        elements[:opponent] = "日本"
        insert[:"#{elements[:date]}"] = elements
        
      end
      p insert

      # # DB追加用データ成形
      # elements[:date].count.times do |m|
      #   # 日付
      #   insert[:date][m] = elements[:date][m].inner_text.split("-")
      #   insert[:date][m].each do |i|
      #     insert[:date][m][i].to_i(10)
      #   end
      #   p insert[:date][m]
      #   # p insert[:date][m]
      #   # ホームアンドアウェー
      #   if elements[:ha][m].inner_text == "H"
      #     insert[:home_team][m] = "日本"
      #     insert[:away_team][m] = elements[:opponent][m].inner_text
      #     p elements[:ha][m].inner_text
      #     p elements[:opponent][m].inner_text
      #     p insert[:home_team][m]
      #     p insert[:away_team][m]
      #   elsif elements[:ha][m].inner_text == "A"
      #     insert[:home_team][m] = elements[:opponent][m].inner_text
      #     insert[:away_team][m] = "日本"
      #     p elements[:ha][m].inner_text
      #     p elements[:opponent][m].inner_text
      #     p insert[:home_team][m]
      #     p insert[:away_team][m]
      #   elsif elements[:ha][m].inner_text == "N"
      #     insert[:home_team][m] = "日本"
      #     insert[:away_team][m] = elements[:opponent][m].inner_text
      #     p elements[:ha][m].inner_text
      #     p elements[:opponent][m].inner_text
      #     p insert[:home_team][m]
      #     p insert[:away_team][m]
      #   end
      #   # p elements[:ha][m].inner_text
      #   # p "home_team→" + insert[:home_team][m]
      #   # p "away_team→" + insert[:away_team][m]
      #   # p elements[:opponent][m].inner_text
      #   # スコア
      #   insert[:home_gf] = elements[:score][m].inner_text.split(" - ")[0]
      #   insert[:away_gf] = elements[:score][m].inner_text.split(" - ")[1]
      #   # # p elements[:score][m]
      #   # p insert[:away_gf] = elements[:score][m][1]
        
      # #   p "ha→" + elements[:ha][m]
      # #   p "opponent→" + elements[:opponent][m]
      # #   Game.create!()
      # #   2変数を順番に指定
      # #   puts elements[:date][m].inner_text + elements[:opponent][m].inner_text
      # end
    end
  end
end
