class Admin::CardsController < Admin::ApplicationController
  def index
    @cards = Card.all
  end
end
