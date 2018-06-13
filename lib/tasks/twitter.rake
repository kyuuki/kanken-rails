require 'twitter'

namespace :twitter do
  desc "Tweet kanken question"
  task :post => :environment do
    # https://qiita.com/naoty_k/items/0be1a055932b5b461766
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info "Task twitter:post start."

    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.secrets.twitter_consumer_key
        config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
        config.access_token        = Rails.application.secrets.twitter_access_token
        config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
      end

      card = Card.offset(rand(Card.count)).first
      client.update("「#{card.question}」正解率 #{(card.correct_answer_rate * 100).round(1)}% 答え → http://kanken8.akoba.xyz#{Rails.application.routes.url_helpers.answer_card_path(card)} #漢検 #漢字検定 #漢字")
    rescue => exception
      Rails.logger.fatal "Task twitter:post failed."
      Rails.logger.info exception.message
      raise exception
    end

    Rails.logger.info "Task twitter:post end."
  end
end
