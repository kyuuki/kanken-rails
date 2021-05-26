class LogAction < ApplicationRecord
  belongs_to :client
  belongs_to :card

  ACTION_NG = 1
  ACTION_OK = 2

  paginates_per 30
end
