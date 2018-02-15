class Admin::ClientsController < Admin::ApplicationController
  def index
    @clients = Client.all.order(updated_at: :desc)
  end

  def show
    @client = Client.find(params[:id])
    @log_actions = @client.log_actions.order(id: :desc).includes(:card)
  end
end
