class Admin::CardsController < Admin::ApplicationController
  def index
    @ransack = Card.ransack(params[:q])
    @ransack.sorts = "id DESC"
    @cards = @ransack.result.page(params[:page])
  end

  def show
    @card = Card.find(params[:id])
    @log_actions = @card.log_actions.order(id: :desc).includes(:client)
  end

  def new
    @card = Card.new
  end

  def edit
    @card = Card.find(params[:id])
  end

  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        CardOwner.create(card: @card, admin_user: current_admin_user)  # TODO: トランザクションできちんと
        notifier = Slack::Notifier.new(Rails.application.secrets.slack_webhook_url,
                                       channel: "#random", username: "kanken-rails")
        notifier.ping "漢検問題追加: #{@card.question}"

        format.html { redirect_to admin_cards_url, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to admin_cards_url, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card = Card.find(params[:id])

    @card.destroy
    respond_to do |format|
      format.html { redirect_to admin_cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def card_params
      params.require(:card).permit(:app_id, :question, :answer, :comment)
    end
end
