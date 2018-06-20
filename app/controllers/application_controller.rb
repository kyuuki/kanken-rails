class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_client
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      "admin"
    else
      "application"
    end
  end

  def current_client
    client_id = get_client_id_from_cookies

    client = nil
    if not client_id == nil
      client = Client.find_by_id(client_id)
      if client == nil
        # TODO: おかしい…のでログ出したい。client_id は以下で再設定
      end
    end

    if client == nil
      #
      # 新規クライアント
      #
      client = Client.new
      client.set_from_request(request)

      if client.is_bot?
        client.id = 1  # TODO: nil でもいい？
      else
        client.save  # TODO: エラー処理
        set_client_id_to_cookies(client.id)
      end
    else
      #
      # 既存クライアント
      #
      client.set_from_request(request)
      client.touch  # 値に変更がない場合も更新
      client.save  # TODO: エラー処理
    end

    return client
  end

  def get_client_id_from_cookies
    return cookies.permanent.signed[:client_id]
  end

  def set_client_id_to_cookies(client_id)
    cookies.permanent.signed[:client_id] = client_id
  end

  def set_client
    @client = current_client
  end
end
