require 'twitter'

namespace :twitter do
  desc "Tweet kanken question"
  task :post => :environment do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end

    card = Card.offset(rand(Card.count)).first
    client.update("「#{card.question}」 答え → http://kanken.akoba.xyz#{Rails.application.routes.url_helpers.answer_card_path(card)} #漢検")
  end
end
