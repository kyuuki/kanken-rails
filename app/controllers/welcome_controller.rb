class WelcomeController < ApplicationController
  def index
    @next_card = Card.offset(rand(Card.count)).first

    redirect_to @next_card
  end
end
