#
# Slack 通知
#
# - SlackNotifier だとくどい気がするけど、Slack だと Gem と名前がかぶるのでこの名前にした
#
module SlackNotifier
  #
  # 通知に失敗しても例外は発生させないライトバージョン
  #
  # - Slack 通知に失敗してもシステムを止めたくない (エラー表示したくない) 場合に使用する
  #
  def self.notify(message)
    webhook_url = ENV["SLACK_WEBHOOK_URL"]
    channel = "#notification"
    username = "kanken"

    # TODO: notifer は毎回 new する必要はなさげ。シングルトン？
    notifier = Slack::Notifier.new(webhook_url, channel: channel, username: username)

    begin
      notifier.ping(message)
    rescue => e
      # TODO: 特定のタグでログ監視に引っ掛けるしくみ
      # TODO: タグ ([] な記号) の直打ちは止める
      Rails.logger.error "[ERROR] Fail to ping by Slack::Notifier."
      Rails.logger.error e
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  # TODO: 例外を発生させるバージョン
end
