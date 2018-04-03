class CreateCardOwners < ActiveRecord::Migration[5.1]
  def change
    create_table :card_owners do |t|
      t.references :card, foreign_key: true
      t.references :admin_user, foreign_key: true

      t.timestamps
    end
  end
end
