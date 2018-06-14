class App < ApplicationRecord
  has_one :app_twitter_setting
  accepts_nested_attributes_for :app_twitter_setting

  has_many :cards
end
