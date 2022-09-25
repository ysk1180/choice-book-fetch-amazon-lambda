require 'vacuum'
require 'amazon_book'
require 'amazon_book_display'

class AmazonGetItem
  attr_reader :isbn

  def initialize(isbn)
    @isbn = isbn
  end

  def run
    amazon_book = AmazonBook.find_book(isbn)
    return amazon_book.display if amazon_book

    amazon_book_display = AmazonBookDisplay.new(item, isbn_10)
    AmazonBook.new(isbn: isbn).save_with(amazon_book_display)
    amazon_book_display.build_response
  end

  def item
    @item ||= request.dig('ItemsResult', 'Items')&.first
  end

  private

  def client
    @client ||= Vacuum.new(marketplace: 'JP',
                           access_key: ENV['API_ACCESS_KEY'],
                           secret_key: ENV['API_SECRET_KEY'],
                           partner_tag: ENV['ASSOCIATE_TAG'])
  end

  def request
    client.get_items(item_ids: [isbn_10],
                     # browser_node_id: 466298,
                     # merchant: 'Amazon',
                     resources: [
                       'ItemInfo.Title',
                       'Images.Primary.Medium',
                       'ItemInfo.ContentInfo',
                     ]).to_h
  end

  # Amazonの仕様でISBN10桁しかダメだった。変換の参考にしたサイト：https://qiita.com/jnchito/items/b8be26ce87b56c9341ae
  def isbn_10
    @isbn_10 ||= (body = isbn[3..-2])
        .each_char.with_index
        .inject(0) { |sum, (c, i)| sum + c.to_i * (10 - i) }
        .then { |sum| 11 - sum % 11 }
        .then { |raw_digit| { 10 => 'X', 11 => 0 }[raw_digit] || raw_digit }
        .then { |digit| "#{body}#{digit}" }
  end
end
