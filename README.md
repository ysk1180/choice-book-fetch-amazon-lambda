# choice-book-fetch-amazon-lambda
技術書選びの Amazon 情報取得 API（AWS Lambda デプロイ用）

## リリースフロー

- Gem の変更を行なったとき

```
docker run -v `pwd`:/var/task -it lambci/lambda:build-ruby2.7 bundle install --path vendor/bundle
```
（参考：https://teratail.com/questions/206480 ）

- ファイルの圧縮

```
zip -r function.zip lambda_function.rb amazon_book.rb amazon_book_display.rb amazon_get_item.rb amazon_get_review.rb vendor
```

- AWS コンソールの Lambda の画面から `function.zip` をアップロード
