class Client < ApplicationRecord
  def get_next_card(prev_card)
    # 3 つ前が間違えだったらそれを出題
    log_action = LogAction.where(client: self).order(id: :desc).limit(3 + 1).last
    # TODO: log_action がない場合がある？
    return log_action.card if log_action.action == 1

    # ランダムに次のカードを決める
    loop do
      next_card = Card.offset(rand(Card.count)).first
      return next_card if next_card.id != prev_card.id  # 違うのがでたら止める
    end
  end
end
