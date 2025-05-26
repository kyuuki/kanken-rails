class CardsController < ApplicationController
  def show
    @card = Card.find(params[:id])

    @latest_log_actions = LogAction.where(client: @client, card: @card).where.not(action: nil).order(id: :desc).limit(10)
  end

  def answer
    @card = Card.find(params[:id])

    # 解答表示ログ記録
    if not @client.is_bot?
      LogAction.create(client: @client, card: @card)
    end
  end

  def action
    if @client.is_bot?
      redirect_to root_path
      return
    end

    card = Card.find(params[:id])

    # TODO: 本当はトランザクション

    # アクションログ記録
    if not params[:act].nil? and not @client.is_bot?
      log_action = LogAction.where(client: @client).order(id: :desc).first
      if log_action.card.id == card.id
        log_action.action = params[:act]
        log_action.save  # TODO: エラー処理
      end
    end

    # カードにアクションを起こすたびに正答率更新
    card.update_rate_ok

    # クライアントのカード毎の結果を記録
    ClientCardResult.update(@client, card)

    # 次のカードを決める
    next_card = Card.get_next_card(@client)

    redirect_to next_card
  end

  # 正答率一覧
  def results
    # ボットには表示させない
    render plain: "ok" and return if browser.bot?

    @cards = Card.order_by_rate_ok_client(@client).page(params[:page]).per(10)
  end
end
