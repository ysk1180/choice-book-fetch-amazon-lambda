require 'aws-sdk-dynamodb'
require 'date'

class AmazonBook
  attr_reader :isbn, :title, :page_count, :image_url, :review_score, :review_count, :link

  def initialize(args)
    @isbn = args[:isbn]
    @title = args[:title]
    @page_count = args[:page_count].to_i if args[:page_count]
    @image_url = args[:image_url]
    @review_score = args[:review_score].to_f if args[:review_score]
    @review_count = args[:review_count].to_i if args[:review_count]
    @link = args[:link]
  end

  def self.find_book(isbn)
    search_params = {
      table_name: 'ChoiseBookAmazonBooks',
      key: {
        isbn: isbn
      }
    }
    result = dynamodb_client.get_item(search_params)

    return if result.item.nil?

    i = result.item
    new(
      isbn: i['isbn'],
      title: i['title'],
      page_count: i['page_count'],
      image_url: i['image_url'],
      review_score: i['review_score'],
      review_count: i['review_count'],
      link: i['link'],
    )
  end

  def display
    {
      amazon_image_url: image_url,
      page_count: page_count,
      amazon_review_score: review_score,
      amazon_review_count: review_count,
      amazon_link: link,
    }
  end

  def save_with(amazon_book_display)
    save_params = {
      table_name: 'ChoiseBookAmazonBooks',
      item: {
        isbn: isbn,
        title: amazon_book_display.title,
        page_count: amazon_book_display.page_count,
        image_url: amazon_book_display.image_url,
        review_score: amazon_book_display.review_score,
        review_count: amazon_book_display.review_count,
        link: amazon_book_display.link,
        updated_at: DateTime.now.iso8601
      }
    }
    dynamodb_client.put_item(save_params)
  end

  private

  def self.dynamodb_client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
  end

  def dynamodb_client
    @dynamodb_client ||= Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
  end
end
 