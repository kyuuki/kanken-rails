class Card < ApplicationRecord
  has_many :log_actions
  has_many :client_card_results
  has_one :card_owner

  def count_action_ok
    # 1 はなんとかせな
    self.log_actions.where(action: LogAction::ACTION_OK).count
  end

  def count_action_ng
    self.log_actions.where(action: LogAction::ACTION_NG).count
  end

  # 正答率
  def correct_answer_rate
    count_action_ok = self.count_action_ok
    count_action_ng = self.count_action_ng

    return 0 if (count_action_ok + count_action_ng) == 0

    # どっちがか float なら結果も float
    return count_action_ok / (count_action_ok + count_action_ng).to_f
  end

  # TODO: あとで効率化
  def correct_answer_rate_by_client(client)
    result = ClientCardResult.find_by(client: client, card: self)
    if result.nil?
      return nil
    else
      return result.rate_ok
    end
  end
end
