class Card < ApplicationRecord
  has_many :log_actions

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
end
