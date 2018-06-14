class CreateAppTwitterSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :app_twitter_settings do |t|
      t.references :app, foreign_key: true
      t.string :consumer_key
      t.string :consumer_secret
      t.string :access_token
      t.string :access_token_secret
      t.text :message

      t.timestamps
    end
  end
end
