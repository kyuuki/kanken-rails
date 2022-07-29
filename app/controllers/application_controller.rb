class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_client

  private

  #
  # 汚いけど、今はユーザーベースというよりクライアントベース
  #
  # 1 つのクライアントを複数のユーザーでログインもありうる (Cookie をクリアしないなど)
  #
  def current_client
    # ログインしていたらそこからクライアントを特定 (ここだけユーザーに依存)
    if user_signed_in?
      if current_user.clients.count > 0
        # 現状、新規登録完了時にだけ結びつけてるので、1 ユーザーに複数のクライアントは登録されてないはず (逆はある)
        return current_user.clients.first
      end
    end

    if browser.bot?
      # ボットにも通常通り画面は見せたい (保存したくないだけ)
      client = Client.new
      client.id = 1  # TODO: nil でもいい？
      return client
    end
    
    # TODO: 将来的には複数のクライアントでのログインを検知したい
    
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
