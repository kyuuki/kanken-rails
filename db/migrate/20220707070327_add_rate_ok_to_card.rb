class AddRateOkToCard < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :rate_ok, :float, null: false, default: 0
  end
end
