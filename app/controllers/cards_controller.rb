class CardsController < ApplicationController
  def show
    client = current_client
    @card = Card.find(params[:id])

    @log_last_action = LogAction.where(client: client, card: @card).order(id: :desc).limit(10)
  end

  def answer
    client = current_client
    @card = Card.find(params[:id])

    # 解答表示ログ記録
    LogAction.create(client: client, card: @card)
  end

  def action
    client = current_client
    card = Card.find(params[:id])

    # アクションログ記録
    unless params[:act].nil?
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
