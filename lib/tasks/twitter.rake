require 'twitter'

namespace :twitter do
  desc "Tweet kanken question"
  task :post, [ 'card_id' ] => :environment do |task, args|
    # https://qiita.com/naoty_k/items/0be1a055932b5b461766
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info "Task twitter:post start."
    Rails.logger.info "card_id = #{args.card_id}"

    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      end

      if args.card_id.nil?
        card = Card.offset(rand(Card.count)).first
      else
        card = Card.find(args.card_id.to_i)
      end
      client.update("「#{card.question}」正解率 #{(card.correct_answer_rate * 100).round(1)}% 答え → #{Rails.configuration.setting.url}#{Rails.application.routes.url_helpers.answer_card_path(card)} #漢検")
    rescue => exception
      Rails.logger.fatal "Task twitter:post failed."
      Rails.logger.info exception.message
      raise exception
    end

    Rails.logger.info "Task twitter:post end."
  end
end
