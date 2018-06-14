class AppsController < ApplicationController
  def show
    @app = App.find(params[:id])

    puts template_exists?("show", "cards")
    puts template_exists?("_nav", "layouts")
    puts template_exists?("nav", "layouts")

    #render "#{@app.identifier}/show", layout: "#{@app.identifier}"
    #render "show", layout: "#{@app.identifier}"
    render :show
  end

  def start
    @app = App.find(params[:app_id])
    next_card = @app.cards.offset(rand(@app.cards.count)).first

    redirect_to app_card_path(@app, next_card)
  end
end
