require 'open-uri'
require 'mechanize'

namespace :scrape do
  desc '日本代表の試合を日本代表DBから取得'
  task :scrape_match_data => :environment do
    
    agent = Mechanize.new
    
    # elements = Hash.new
    elements = Hash.new( {} ) # 多重ハッシュ用の初期化
    insert = Hash.new( {} ) # 多重ハッシュ用の初期化
    
    #繰り返しで変数に入れる処理
    for n in 1923..2016 do
    # for n in 1923..1925 do # 1923～1925年のページ
      @page = agent.get("http://www.japannationalfootballteam.com/#{n}")
      
      next unless @page.search('title').inner_text.include?("サッカー日本代表データベース")
      
      
      @page.search('table.results td.date').count.times do |i|
        # データ取得
        date = @page.search('table.results td.date'  )[i].inner_text
        insert["#{date}"] = Hash.new();
        elements[:date] =       @page.search('table.results td.date'  )[i].inner_text
        elements[:opponent] =   @page.search('table.results td.opp a' )[i].inner_text
        elements[:ha] =         @page.search('table.results td.ha'    )[i].inner_text
        elements[:score] =      @page.search('table.results td.score' )[i].inner_text
        elements[:venue] =      @page.search('table.results td.venue' )[i].inner_text
        elements[:tournament] = @page.search('table.results td.comp'  )[i].inner_text
        
        elements.each do |key, val|
          insert["#{date}"][key] = val
        end
      end
      

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
    # DB追加用データ成形
    insert.each do |date,data|
      # 日付
      
      # data[:date] = Date.new(data[:date].split("-").map(&:to_i))
      data[:date] = Date.parse( data[:date] )
      
      # チーム、得点
      data[:score] = data[:score].split(" - ").map(&:to_i)
      if data[:ha] == ( "H" || "N" )
        data[:home_team] = "日本"
        data[:away_team] = data[:opponent]
        data[:home_gf] = data[:score][0]
        data[:away_gf] = data[:score][1]
      else
        data[:home_team] = data[:opponent]
        data[:away_team] = "日本"
        data[:home_gf] = data[:score][1]
        data[:away_gf] = data[:score][0]
      end
      data.delete(:opponent)
      data.delete(:ha)
      data.delete(:score)
      
      Game.create!( data ) unless Game.find_by( date: data[:date])
      
    end
  end
end
