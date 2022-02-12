class Card < ApplicationRecord
  has_many :log_actions, dependent: :destroy
  has_many :client_card_results, dependent: :destroy
  has_one :card_owner, dependent: :destroy

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

  # 検索の時に使うキーワード
  def keyword_for_search
    return question.gsub(/\(.*\)/, "").gsub(/（.*）/, "").strip
  end

  #
  # 次のカード取得
  #
  # - LogAction が少ない場合に注意
  # - カードが少ない場合に注意
  #
  def self.get_next_card(client)
    # 3 つ前が間違いだったらそれを出題
    log_actions = LogAction.where(client: client).order(created_at: :desc).limit(3 + 1)  # 最新の 4 つの結果 (今回のも含む)
    log_action_this_time = log_actions.first  # 今回の結果
    log_action_prev_3    = log_actions.last   # 3 つ前の結果
    if (log_actions.size == 4)  # まだ 4 回答えてない場合は無視
      if (log_action_prev_3.action == LogAction::ACTION_NG)
        return log_action_prev_3.card
      end
    end

    # カード 1 枚だけの場合は毎回、今回と同じになってしまうため、特別処理
    return Card.last if Card.count == 1

    # ランダムに次のカードを決める (カード 1 枚だけだと無限ループ)
    loop do
      next_card = Card.offset(rand(Card.count)).first
      return next_card if next_card.id != log_action_this_time.card.id  # 違うのがでたら止める
    end
  end
end
