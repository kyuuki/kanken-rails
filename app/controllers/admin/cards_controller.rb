class Admin::CardsController < Admin::ApplicationController
  def index
    @cards = Card.order(:id)
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
      params.require(:card).permit(:question, :answer, :comment)
    end
end
