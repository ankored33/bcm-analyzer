require 'sinatra'
require 'sinatra/reloader' if development?
require 'nokogiri'
require 'open-uri'
require "json"

=begin
ruby main.rb -p $PORT -o $IP
export MECAB_PATH=/usr/lib/libmecab.so.2
=end

get "/" do
  erb :index
end

post "/post" do
  
user = params[:hatena_id]
param = 0
comments = Array.new
c = 0
sile = 0
posi = 0
nega = 0
neut = 0 #ブクマ数,無言コメ,ポジコメ,ネガコメ,ニュートラルコメ
arr = Array.new
key_nega = [
  "噴飯",
  "クズ", "ゴミ", "カス",
  "売名",
  "キチガイ", "基地外",
  "ハゲ",
  "つまら", "つまん",
  "氏ね", "死ね",
  "最悪",
  "メンヘラ",
  "嫌い", "むかつく", "ムカつく",
  "ふざけるな", "ふざけんな",
  "最高にアホ",
  "やりなおし", "やり直し",
  "無能",
  "失笑",
  "ダサい", "だせえ", "ダセえ",
  "ジャップ","土人", "乞食",
  "頭悪", "頭が悪",
  "可哀想","かわいそう",
  "老害","連中",
  "お前が言うな", "おまいう",
  "くだらな"
  ]

key_n_top = [
  "クソ","糞"
  ]

key_posi = [
  "いい意味で",
  "ワロタ", "ワラタ", "笑った", "わらた", "わろた", "笑う",
  "楽しい", "楽しか", "楽しみ", "たのしみ", "たのしそ", "楽しそ",
  "すごい", "凄い", "すごか", "凄か",
  "おいしい", "美味しい", "うまい", "上手い",
  "面白い", "面白か", "おもしろい", "おもしろか", "面白そ", "おもしろそ","面白す", "おもしろす",
  "うける", "ウケる",
  "良エントリ", "良記事", "いいエントリ","良いエントリ", "いいな", "良いな", "良い話", "いい話", "良いね",
  "最高",
  "なるほど", "納得。",
  "好き。", "好き　","好きす",
  "称賛し", "賞賛し",
  "がんばれ", "がんばった", "頑張れ", "頑張った",
  "ありがとう", "ありがたい",
  "気持ちのいい",
  "革新的",
  "センスいい","センスがいい","ハイセンス","センスある",
  ]

opt = {}
opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 ' #User-Agent偽装
charset = nil

while param < 100 do
  url = "http://b.hatena.ne.jp/#{user}/atomfeed?of=#{param}"
  atom = open(url,opt) do |f|
    charset = f.charset #文字種別を取得
    f.read 
  end
  doc = Nokogiri::XML(atom)
  doc.remove_namespaces!

  doc.xpath('//entry').each {|e|
    cmt = e.xpath('summary').inner_text
    tag = e.xpath('subject').inner_text
    ent = e.xpath('link')[0][:href]
    dom = ent[/https?:\/\/.+?\//]
    arr << dom
    sile += 1 if cmt == ""
    c += 1
    feel = 0
    key_n_top.each {|key|
      feel -= 1 if cmt.include?(key) == true
    }
    key_posi.each {|key|
      feel += 2 if cmt.include?(key) == true
    }
    key_nega.each {|key|
      feel -= 3 if cmt.include?(key) == true
    }
    if feel > 0 then
      val = "positive"
      posi += 1
    elsif feel < 0 then
      val = "negative"
      nega += 1
    else
      val = "neutral"
      neut += 1
    end
    comments << [cmt,val,tag,ent]
  } 
  param += 20
  puts "#{param}件取得"
end
  comments << [c, sile, posi, nega, neut]
  arr.select! {|v| arr.count(v) > 1 }  
class Array
  def count_to_hash
    k = Hash.new(0)
    self.each{|x| k[x] += 1 }
    return k
  end
end

items = arr.count_to_hash
comments << items.sort_by{|key,val| -val}

p comments

content_type :json
@data = comments.to_json

end