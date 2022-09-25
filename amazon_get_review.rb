require 'nokogiri'
require 'anemone'
require 'open-uri'

class AmazonGetReview
    attr_reader :isbn_10
  
    def initialize(isbn_10)
      @isbn_10 = isbn_10
    end
  
    # APIがレビューに対応してないのでサイトから取得。参考にしたサイト：https://blog.tsurubee.tech/entry/2016/06/26/214729
    def rate
      @rate ||= doc.xpath('//*[@id="cm_cr-product_info"]/div/div[1]/div[2]/div/div/div[2]/div/span').text.match(/星5つ中の(.+)/)&.captures&.first.to_f
    end
  
    def count
      @count ||= doc.xpath('//*[@id="cm_cr-product_info"]/div/div[1]/div[3]/span').text.split.first.to_i
    end
  
    private
  
    def doc
      @doc ||= get_html
    end
  
    def get_html
      Nokogiri::HTML(URI.open(url))
    rescue
      Nokogiri::HTML(URI.open(url)) # よくエラーするから簡易リトライ機構
    end
  
    def url
      "https://www.amazon.co.jp/product-reviews/#{isbn_10}"
    end
  end
  