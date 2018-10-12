# coding: utf-8
class ClientCardResult < ApplicationRecord
  belongs_to :client
  belongs_to :card

  def self.update(client, card)
    result = ClientCardResult.find_or_create_by(client: client, card: card)

    # 正解数、不正解数、正答率を設定
    count_ok = LogAction.where(client: client, card: card, action: LogAction::ACTION_OK).count
    count_ng = LogAction.where(client: client, card: card, action: LogAction::ACTION_NG).count
    result.count_ok = count_ok
    result.count_ng = count_ng
    result.rate_ok = correct_answer_rate(count_ok, count_ng)

    # 最後の正解日を設定
    last_log_action = LogAction.where(client: client, card: card, action: LogAction::ACTION_OK).order(:created_at).last

    if not last_log_action.nil?
      result.last_ok_at = last_log_action.created_at
    end

    result.save
  end

  # 正答率
  def self.correct_answer_rate(count_ok, count_ng)
    return 0 if (count_ok + count_ng) == 0

    # どっちがか float なら結果も float
    return count_ok / (count_ok + count_ng).to_f
  end

end
