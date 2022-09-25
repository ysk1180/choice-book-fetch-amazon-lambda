require 'amazon_get_review'

class AmazonBookDisplay
    attr_reader :item, :isbn_10
  
    def initialize(item, isbn_10)
      @item = item
      @isbn_10 = isbn_10
    end
  
    def build_response
      {
        amazon_image_url: image_url,
        page_count: page_count,
        amazon_review_score: review_score,
        amazon_review_count: review_count,
        amazon_link: link,
      }
    end
  
    def title
      @title ||= item.dig('ItemInfo', 'Title', 'DisplayValue')
    end
  
    def image_url
      @image_url ||= item.dig('Images', 'Primary', 'Medium', 'URL')
    end
  
    def page_count
      @page_count ||= item.dig('ItemInfo', 'ContentInfo', 'PagesCount', 'DisplayValue')
    end
  
    def review_score
      return @review_score if defined?(@review_score)
      return if review_count.zero?
  
      @review_score = get_review.rate
    end
  
    def review_count
      @amazon_review_count ||= get_review.count
    end
  
    def link
      @link ||= item.dig('DetailPageURL')
    end
  
    def get_review
      @get_review ||= AmazonGetReview.new(isbn_10)
    end
  end
  