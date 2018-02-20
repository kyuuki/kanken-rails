class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_client

  private

  def current_client
    client_id = get_client_id

    client = nil
    if not client_id == nil
      client = Client.find_by_id(client_id)
      set_client_id(nil) if client == nil  # おかしい…なので client_id を一度リセット
    end

    remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip

    if client == nil
      # http://kyamada.hatenablog.com/entry/2012/09/21/195603
      # https://qiita.com/ledsun/items/c947b453ba97661afcef
      client = Client.new(user_agent: request.user_agent, ip: remote_ip, header: Client.make_headers_hash(request).to_json)

      if client.is_bot?
        client.id = 1
      else
        client.save  # TODO: エラー処理
        set_client_id(client.id)
      end
    else
      client.user_agent = request.user_agent
      client.ip = remote_ip
      client.header = Client.make_headers_hash(request).to_json
      client.touch  # 値に変更がない場合も更新
      client.save  # TODO: エラー処理
    end

    return client
  end

  def get_client_id
    return cookies.permanent.signed[:client_id]
  end

  def set_client_id(client_id)
    cookies.permanent.signed[:client_id] = client_id
  end

  def set_client
    @client = current_client
  end
end
