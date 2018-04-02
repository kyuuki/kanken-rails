class AddHeaderToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :header, :string
  end
end
