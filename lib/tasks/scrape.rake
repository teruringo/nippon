require 'open-uri'
require 'mechanize'
require 'logger'

namespace :scrape do
  desc '日本代表の試合を日本代表DBから取得'
  task :scrape_matchs => :environment do
    
    agent = Mechanize.new
    
    elements = Hash.new( {} ) # 多重ハッシュ用の初期化
    insert = Hash.new( {} ) # 多重ハッシュ用の初期化
    
    #繰り返しで変数に入れる処理
    for n in 1923..2016 do
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
    end
    # DB追加用データ成形
    insert.each do |date,data|
      # 日付
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
  
  desc '日本代表の試合の選手情報、得点情報を取得'
  task :scrape_match_detail => :environment do
    agent = Mechanize.new
    
    elements = Hash.new( {} ) # 多重ハッシュ用の初期化
    insert = Hash.new( {} ) # 多重ハッシュ用の初期化

    for n in 1923..1925 do
      @page = agent.get("http://www.japannationalfootballteam.com/#{n}/")
      
      next unless @page.search('title').inner_text.include?("サッカー日本代表データベース")
      
      
      @page.search('table.results td.date').count.times do |i|
        # 試合ページのクリック
        @page.search('table.results td.score').links[i].click
        
        
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
    end
    # DB追加用データ成形
    insert.each do |date,data|
      # 日付
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
      
      # Game.create!( data ) unless Game.find_by( date: data[:date])
      
    end
  end
  
  desc '日本代表の選手を取得'
  task :scrape_players => :environment do
    agent = Mechanize.new
    agent.user_agent_alias = 'Windows IE 9'
    agent.log = Logger.new $stderr
    agent.log.level = Logger::INFO
    
    elements = Hash.new( {} ) # 多重ハッシュ用の初期化
    insert = Hash.new( {} ) # 多重ハッシュ用の初期化
    name_ini = [ "a", "ka", "sa", "ta", "na", "ha", "ma", "ya", "ra", "wa", "unknown" ]
    # name_ini = [ "a" ] # テスト用
    # ページ表示
    # page = agent.get("http://www.japannationalfootballteam.com/players_na/shoichi_nishimura.html")  # テスト用
    name_ini.each do |n|
      page = agent.get("http://www.japannationalfootballteam.com/players_#{n}")

      # 繰り返し
      page.search('table.players td.player').count.times do |i|
      # page.search('table.players td.player').first(1).count.times do |i| # テスト用

        # 選手リンクをクリック
        href_str = page.search('//td[@class="player"]/a/@href')[i].text
        agent.page.link_with(:href => href_str).click

        # ページ内のデータを指定、ハッシュに入れる・データを成形する
        
        # 選手名
        name =  agent.page.search('h1.headline').text
        name = name.split(/（|）/)
        insert[:name]     = name[0].strip!
        insert[:phonetic] = name[1]
        
        # 誕生日、出身地
        insert[:birth_day]   = agent.page.search('div.profile_l').search('table.profile td')[0].text.gsub( /年|月/, "-" ).delete("日")
        insert[:birth_day].match(/\d\d\d\d-\d\d-\d\d/) ? insert[:birth_day] = Date.parse( insert[:birth_day] ) : insert[:birth_day] = nil
        insert[:birth_place] = agent.page.search('div.profile_l').search('table.profile td')[1].text
        
        # 身長、体重
        insert[:height] = agent.page.search('table.profile')[1].search('td')[1].text
        insert[:weight] = agent.page.search('table.profile')[1].search('td')[0].text

        # サイト Twitter FBはまた別に取得する。
        
        # データをDBにcreateする
        Player.create!( insert ) unless Player.find_by( name: insert[:name])

        # 戻る
        agent.back
      end
    end
      

      
    #     date = @page.search('table.results td.date'  )[i].inner_text
    #     insert["#{date}"] = Hash.new();
    #     elements[:date] =       @page.search('table.results td.date'  )[i].inner_text
        
    # http://www.japannationalfootballteam.com/players_a/index.html
  end
end