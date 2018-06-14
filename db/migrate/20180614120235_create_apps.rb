class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :identifier
      t.string :url

      t.timestamps
    end
  end
end
