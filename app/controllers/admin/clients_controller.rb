class Admin::ClientsController < Admin::ApplicationController
  def index
    @clients = Client.all.order(updated_at: :desc)
  end
end
