class CreateLogActions < ActiveRecord::Migration[5.1]
  def change
    create_table :log_actions do |t|
      t.references :client, foreign_key: true
      t.references :card, foreign_key: true
      t.integer :action

      t.timestamps
    end
  end
end
