class CardsController < ApplicationController
  def show
    @card = Card.find(params[:id])
  end

  def answer
    @card = Card.find(params[:id])

    # ランダムに次のカードを決める
    loop do
      @next_card = Card.offset(rand(Card.count)).first
      break if @next_card.id != @card.id  # 違うのがでたら止める
    end
  end
end
