require 'sinatra'
require 'sinatra/reloader' if development?
require 'nokogiri'
require 'open-uri'

get "/" do
  erb :index
end


user = "inmysoul"
param = 0
c = 0
cc = 0
@comments = Array.new

key_gojo = [
  "参考",
  "ですね", "ます"
  ]
  
key_nega = [
  "クズ", "ゴミ", "カス",
  "ハゲ",
  "つまら", "つまん",
  "氏ね", "死ね",
  "最悪",
  "メンヘラ",
  "嫌い",
  "ふざけるな", "ふざけんな",
  "最高にアホ",
  "やりなおし", "やり直し",
  "無能",
  "失笑",
  "ださい","ダサい",
  "ジャップ","土人", "乞食",
  "頭悪",
  ]

key_n_top = [
  "クソ","糞"
  ]

key_posi = [
  "いい意味で",
  "ワロタ", "ワラタ", "笑った", "わらた", "わろた", "笑う",
  "楽しい", "楽しか", "楽しみ", "たのしみ",
  "すごい", "凄い", "すごか", "凄か",
  "おいしい", "美味しい",
  "面白い", "面白か", "おもしろい", "おもしろか", "面白そ", "おもしろそ",
  "うける", "ウケる",
  "良エントリ", "いいエントリ", "いいな", "良いな", "いい話", "良いね",
  "最高",
  "なるほど", "納得。",
  "好き",
  "称賛したい", "賞賛したい",
  "がんばれ", "がんばった", "頑張れ", "頑張った"
  ]

opt = {}
opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1; U; ja) Presto/2.7.62 Version/11.01 ' #User-Agent偽装
charset = nil

while cc <= 100 do
  url = "http://b.hatena.ne.jp/#{user}/atomfeed?of=#{param}"
  atom = open(url,opt) do |f|
    charset = f.charset #文字種別を取得
    f.read 
  end
  doc = Nokogiri::XML(atom)
  doc.remove_namespaces!

  doc.xpath('//entry').each {|e|
    comment = e.xpath('summary').inner_text
    c += 1
    next if comment == ""
    cc += 1
    break if cc > 100
    posi_p = 0
    gojo_p = 0
    key_n_top.each {|key|
      posi_p -= 1 if comment.include?(key) == true
    }
    key_posi.each {|key|
      posi_p += 2 if comment.include?(key) == true
    }
    key_nega.each {|key|
      posi_p -= 3 if comment.include?(key) == true
    }
    key_posi.each {|key|
      gojo_p += 1 if comment.include?(key) == true
    }
  @comments << "#{comment} #####{posi_p}point"
  }
  sleep(0.75)
  param += 20  
end

puts @comments