require 'open-uri'
require 'mechanize'

namespace :scrape do
  desc '日本代表の試合を日本代表DBから取得'
  task :scrape_match_data => :environment do
    
    agent = Mechanize.new

    #繰り返しで変数に入れる処理
    for n in 1923..1925 do
      page = agent.get("http://www.japannationalfootballteam.com/#{n}")
      elements = page.search('table.results tr + tr td.opp')
      elements.each do |ele|
        puts ele.inner_text
      end
    end
  end
end
