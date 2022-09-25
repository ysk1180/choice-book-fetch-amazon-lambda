require 'amazon_get_item'

def lambda_handler(event:, context:)
  isbn = event['isbn']
  return {} if isbn.nil? || isbn == ''

  AmazonGetItem.new(isbn).run
rescue => e # (おそらく)AmazonのAPIのLimitの影響で頻繁にエラーするが、アプリケーション上許容しているので正常系で{}を返す
  p 11111111111
  p e
  p e.full_message
  p e.backtrace
  {}
end