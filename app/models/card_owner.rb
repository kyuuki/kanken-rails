class CardOwner < ApplicationRecord
  belongs_to :card
  belongs_to :admin_user
end
