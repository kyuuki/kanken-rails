class CardsController < ApplicationController
  def show
    client = current_client
    @card = Card.find(params[:id])

    @latest_log_actions = LogAction.where(client: client, card: @card).where.not(action: nil).order(id: :desc).limit(10)
  end

  def answer
    client = current_client
    @card = Card.find(params[:id])

    # 解答表示ログ記録
    if not client.is_bot?
      LogAction.create(client: client, card: @card)
    end
  end

  def action
    client = current_client
    card = Card.find(params[:id])

    # アクションログ記録
    if not params[:act].nil? and not client.is_bot?
      log_action = LogAction.where(client: client).order(id: :desc).first
      if log_action.card.id == card.id
        log_action.action = params[:act]
        log_action.save  # TODO: エラー処理
      end
    end

    # 次のカードを決める
    next_card = client.get_next_card(card)

    redirect_to next_card
  end
end
