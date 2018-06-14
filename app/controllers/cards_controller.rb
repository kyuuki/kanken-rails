class CardsController < ApplicationController
  def show
    @app = App.find(params[:app_id])
    @card = Card.find(params[:id])

    @latest_log_actions = LogAction.where(client: @client, card: @card).where.not(action: nil).order(id: :desc).limit(10)

    #if not params[:app_id].nil?
    #  render "#{@app.identifier}/cards/show", layout: "#{@app.identifier}"
    #end
  end

  def answer
    @app = App.find(params[:app_id])
    @card = Card.find(params[:id])

    # 解答表示ログ記録
    if not @client.is_bot?
      LogAction.create(client: @client, card: @card)
    end
  end

  def action
    @app = App.find(params[:app_id])
    card = Card.find(params[:id])

    # アクションログ記録
    if not params[:act].nil? and not @client.is_bot?
      log_action = LogAction.where(client: @client).order(id: :desc).first
      if log_action.card.id == card.id
        log_action.action = params[:act]
        log_action.save  # TODO: エラー処理
      end
    end

    # 次のカードを決める
    next_card = @client.get_next_card(card)

    redirect_to app_card_path(@app, next_card)
  end
end
