class CreateClientCardResults < ActiveRecord::Migration[5.1]
  def change
    create_table :client_card_results do |t|
      t.references :client, foreign_key: true
      t.references :card, foreign_key: true
      t.integer :count_ok, null: false, default: 0
      t.integer :count_ng, null: false, default: 0
      t.float :rate_ok, null: false, default: 0
      t.datetime :last_ok_at
      t.integer :point_weak, null: false, default: 50

      t.timestamps
    end
  end
end
