class CreateTwitterVerifiedUsers < ActiveRecord::Migration
  def change
    create_table :twitter_verified_users do |t|
      t.integer :twitter_id
      t.string :data

      t.timestamps
    end
  end
end
