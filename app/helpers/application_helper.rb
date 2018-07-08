module ApplicationHelper
  # title は各ページで決める
  # title がないトップページは og: title を独自に決める
  def default_meta_tags
    {
      site: "漢検 準1級 読み",
      reverse: true,
      description: "只管、漢検準1級の読み問題を出題します。あまり出題頻度の高くないものを中心に出題します。漢検準1級の読みは日本語で書かれた少し難しい文章（明治の文豪の小説など）を読むために必要な知識となります。意味も含めて覚えていきましょう。間違った問題を繰り返し解くことで、漢字の読みを覚えていきます。",
      keywords: [ "漢検", "漢字検定" "準一級", "準1級", "読み", "読み問題", "干支" ],
      canonical: request.original_url,
      og: {
        title: :title,
        type: "website",
        url: request.original_url,
        image: "http://kanjino-terakoya.com/wp-content/uploads/2017/06/yoko2_c.png",
        site_name: :site,
      },
      twitter: {
        card: "summary",
        site: "@kanken_jp",
        image: "http://kanjino-terakoya.com/wp-content/uploads/2017/06/yoko2_c.png",
      },
    }
  end
end
