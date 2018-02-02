class Admin::ClientsController < Admin::ApplicationController
  def index
    @clients = Client.all
  end
end
