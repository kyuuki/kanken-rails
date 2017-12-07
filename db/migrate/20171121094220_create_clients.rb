class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :user_agent
      t.string :ip

      t.timestamps
    end
  end
end
