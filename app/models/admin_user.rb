class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :card_owners

  # XXXX 年 XX 月に作成したカード数
  def count_card_owners_created_in_year_month(year, month)
    date = Date.new(year, month, 1)
    self.card_owners.where(created_at: [date.beginning_of_month.beginning_of_day..date.end_of_month.end_of_day]).count
  end
end
