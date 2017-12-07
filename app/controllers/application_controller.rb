class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_client
    if not session[:clinet_id].nil?
      client = Client.find_by_id(session[:clinet_id])
      session[:clinet_id] = nil if client == nil
    else
      client = nil
    end

    if client == nil
      client = Client.create(user_agent: request.user_agent, ip: request.remote_ip)
      session[:clinet_id] = client.id
    else
      client.user_agent = request.user_agent
      client.ip = request.remote_ip
      client.save  # 値に変更がない場合は更新されない
    end

    return client
  end
end
