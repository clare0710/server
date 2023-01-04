class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :userId
      t.string :image
      t.string :spotify_url
      t.string :uri
      t.string :access_token
      t.string :refresh_token
      t.timestamps
    end
  end
end
