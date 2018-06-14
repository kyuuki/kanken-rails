class AddAppToCard < ActiveRecord::Migration[5.1]
  def change
    add_reference :cards, :app, foreign_key: true
  end
end
