class WelcomeController < ApplicationController
  def index
    @cards = Card.order(:id)
  end

  def start
    next_card = Card.offset(rand(Card.count)).first

    redirect_to next_card
  end
end
