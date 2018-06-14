class WelcomeController < ApplicationController
  def index
    @ransack = Card.ransack(params[:q])
    @ransack.sorts = "id DESC"
    @cards = @ransack.result.page(params[:page]).per(10)

    render plain: "What we can not speak about we pass over in silence."
  end

  def start
    next_card = Card.offset(rand(Card.count)).first

    redirect_to next_card
  end
end
