class CardsController < ApplicationController
  def show
    @card = Card.find(params[:id])
  end

  def answer
    @card = Card.find(params[:id])

    # ランダムに次のカードを決める (同じ可能性あり)
    @next_card = Card.offset(rand(Card.count)).first
  end
end
