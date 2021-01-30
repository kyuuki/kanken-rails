class Admin::UsersController < Admin::ApplicationController
  def index
    @ransack = User.ransack(params[:q])
    @users = @ransack.result.order(updated_at: :desc).page(params[:page])
  end

  def show
    @client = Client.find(params[:id])
    @log_actions = @client.log_actions.order(id: :desc).includes(:card)
  end
end
