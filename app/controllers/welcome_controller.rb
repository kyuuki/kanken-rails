class WelcomeController < ApplicationController
  def index
    @cards = Card.order(id: :desc).page(params[:page]).per(10)
  end

  def start
    next_card = Card.offset(rand(Card.count)).first

    redirect_to next_card
  end
end
