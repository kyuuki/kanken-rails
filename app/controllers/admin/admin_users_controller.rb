class Admin::AdminUsersController < Admin::ApplicationController
  def index
    @admin_users = AdminUser.all.order(:id)
  end
end
