class Client < ApplicationRecord
  has_many :log_actions

  def self.new_from_request(request)
    # http://kyamada.hatenablog.com/entry/2012/09/21/195603
    # https://qiita.com/ledsun/items/c947b453ba97661afcef
    remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip

    headers_hash = self.make_headers_hash(request)

    client = Client.new(user_agent: request.user_agent, ip: remote_ip, header: headers_hash.to_json)
    client.set_headers_hash(headers_hash)

    return client
  end

  def self.make_headers_hash(request)
    header_keys = [
                   "HTTP_HOST",
                   "HTTP_ACCEPT",
                   "HTTP_ACCEPT_ENCODING",
                   "HTTP_ACCEPT_LANGUAGE",
                   "HTTP_REFERER",
                  ]

    # かっこつける必要なさげ
    # hash = header_keys.inject({}) { |h, v| h[v] = request.headers[v]; h }
    hash = {}
    header_keys.each do |key|
      hash[key] = request.headers[key]
    end

    return hash
  end

  # リクエストからクライアント情報を設定する
  def set_from_request(request)
    # http://kyamada.hatenablog.com/entry/2012/09/21/195603
    # https://qiita.com/ledsun/items/c947b453ba97661afcef
    remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip

    headers_hash = Client.make_headers_hash(request)

    self.user_agent = request.user_agent
    self.ip         = remote_ip
    self.header     = headers_hash.to_json
    self.set_headers_hash(headers_hash)
  end

  def set_headers_hash(hash)
    @headers_hash = hash
  end

  def get_header_value(header_key)
    if @headers_hash.nil?
      @headers_hash = JSON.parse(header)  # TODO: エラー処理
    end

    return @headers_hash[header_key]
  end

  # ボットかどうか？
  def is_bot?
    # User agent チェック
    if not user_agent.match(/ Googlebot\//).nil?
      return true
    elsif not user_agent.match(/Twitterbot\//).nil?
      return true
    elsif not user_agent.match(/Applebot\//).nil?
      # Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/600.2.5 (KHTML, like Gecko) Version/8.0.2 Safari/600.2.5 (Applebot/0.1; +http://www.apple.com/go/applebot)
      # https://support.apple.com/ja-jp/HT204683
      return true
    elsif not user_agent.match(/Yahoo! Slurp;/).nil?
      # Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)
      return true
    elsif not user_agent.match(/ AhrefsBot\//).nil?
      # Mozilla/5.0 (compatible; AhrefsBot/5.2; News; +http://ahrefs.com/robot/)
      return true
    elsif not user_agent.match(/MetaURI API/).nil?
      # MetaURI API/2.0 +metauri.com
      return true
    elsif not user_agent.match(/facebookexternalhit\//).nil?
      # facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)
      return true
    end

    # ボットっぽい HTTP ヘッダチェック
    if get_header_value("HTTP_ACCEPT_LANGUAGE").nil?
      return true
    end

    # ドイツから来る変なアクセスはボット認定
    if (get_header_value("HTTP_ACCEPT_LANGUAGE") == "en-gb,en;q=0.5") && ip.start_with?("144.76.")
      return true
    end

    return false
  end

  # 自分のクライアントかどうか？
  def is_home?
    if ip == Rails.application.secrets.home_ip
      return true
    end

    return false
  end

  # TODO: Client はできるだけ独立にしたいので別の場所に移動
  def get_next_card(prev_card)
    # 3 つ前が間違えだったらそれを出題
    log_action = LogAction.where(client: self).order(id: :desc).limit(3 + 1).last
    # TODO: log_action がない場合がある？
    return log_action.card if log_action.action == 1

    # ランダムに次のカードを決める
    loop do
      next_card = Card.offset(rand(Card.count)).first
      return next_card if next_card.id != prev_card.id  # 違うのがでたら止める
    end
  end
end
