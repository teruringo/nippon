require 'open-uri'
require 'mechanize'

namespace :scrape do
  desc '日本代表の試合を日本代表DBから取得'
  task :scrape_match_data => :environment do
    
    agent = Mechanize.new
    
    #繰り返しで変数に入れる処理
    for n in 1923..1925 do
      page = agent.get("http://www.japannationalfootballteam.com/#{n}")
      
      next unless page.search('title').inner_text.include?("サッカー日本代表データベース")
      
      elements = Hash.new( {} ) # 多重ハッシュ用の初期化
      elements[:date] = page.search('table.results tr + tr td.date')
      elements[:opponent] = page.search('table.results tr + tr td.opp')
      elements[:ha] = page.search('table.results tr + tr td.ha')
      elements[:score] = page.search('table.results tr + tr td.score')
      elements[:venue] = page.search('table.results tr + tr td.venue')
      elements[:tournament] = page.search('table.results tr + tr td.comp')

      #2変数を順番に指定
      elements[:date].count.times do |m|
        puts elements[:date][m].inner_text + elements[:opponent][m].inner_text
      end
    end
  end
end
