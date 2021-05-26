class Admin::ClientsController < Admin::ApplicationController
  def index
    @ransack = Client.ransack(params[:q])
    @clients = @ransack.result.order(updated_at: :desc).page(params[:page])
  end

  def show
    @client = Client.find(params[:id])
    @log_actions = @client.log_actions.order(id: :desc).includes(:client).page(params[:page])
  end
end
