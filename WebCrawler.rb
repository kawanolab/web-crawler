require 'anemone'
require 'nokogiri'
require 'robotex'

#テスト

class AlphaNum

  def self.table
    @@table ||= '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
  end

  def self.encode(num)
    num > 61 ? self.encode(num/62)+self.table[num%62] : self.table[num%62]
  end


  def self.decode(str)
    arr = str.split('').map{|i| self.table.index i }
    for i in 0...arr.size do
      return arr[i] if i == arr.size-1
      arr[i+1] += arr[i]*62
    end
  end
end

def self.secondpointextraction(origin)
  split = origin.scan(/.{1,#{3}}/)
  xstring = split[0]
  ystring = split[1]

# 10進数に変換
xdec = AlphaNum.decode xstring
ydec = AlphaNum.decode ystring

puts "#{origin}""→原点"
puts "#{xstring}""→上3桁"
puts "#{ystring}""→下3桁"

xresult = Array.new(3)
yresult = Array.new(3)

xresult[0] = xdec-1
xresult[1] = xdec
xresult[2] = xdec+1

yresult[0] = ydec+1
yresult[1] = ydec
yresult[2] = ydec-1


# 10進数の上3桁と下3桁の表示
  puts "原点""#{origin}""の8近傍のx,y座標(10進数)"
for i in 0..2 do
  for j in 0..2 do
  puts "x""("+(xresult[i]).to_s+")"", y""("+(yresult[j]).to_s+")"
  end
end

# 8近傍からの次点抽出
result10 = Array.new(8)

  puts "8近傍を62進数に変換"
for i in 0..2 do
  for j in 0..2 do
  encx = AlphaNum.encode xresult[i]
  ency = AlphaNum.encode yresult[j]

  result10[i*2+j] = "#{encx}#{ency}"

  # 6桁に結合した62進数の表示
  puts "#{result10[i*2+j]}"
  end
end

  nextpoint = (0...1).map {result10[rand(7)]}.join

# 抽出した次点の表示
  puts "8近傍からランダムに次点を抽出"
  puts "#{nextpoint}"

  puts "原点をスクレイピング"
  return nextpoint
end

def createurl(origin)
  urlsource = "http://goo.gl/"
  url = "#{urlsource}#{origin}"
  return url
end

user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
 #オプションの選定
opts = {
  depth_limit: 0, #階層の深さ（0=ルート）
  delay:2, #クローリングの間隔を設定
  skip_query_strings: true, #trueにするとURLのパラメーターを無視する
  "User-Agent" => user_agent, #ユーザーエージェントを設定
   obey_robots_txt:true, #robot.txtに従う場合はtrue
}

  geturl = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
  string = (0...6).map {geturl[rand(geturl.length)]}.join
  #originroop = secondpointextraction(string)
  #puts "string:#{string},originroop:#{originroop}"
  #url = createurl(string)

    #nexturl = creatnexturl

5.times do |i|

# Anemone.crawlにURLとオプションを渡し、Anemoneを起動
  puts "No.#{i}, URL:#{createurl(string)}"
  Anemone.crawl(createurl(string), opts) do |anemone|
    # 指定したURLのすべてのページの情報を取得
    anemone.on_every_page do |page|

#`mono Analyzer.exe`

    # 取得したページをdocメソッドに渡し、Nokogiri形式にして、xpathで要素を絞り込む
    begin
      #page.doc.xpath("/html").each do |node|
      page.doc.xpath("/html/body//b").each do |node|
        # 出力
        puts node
        #p "#{url}"
        #p "#{nexturl}"
        end
    rescue
      puts "エラー"
      end
    end
  end

  string = secondpointextraction(string)
end
