class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.references :twitter_verified_user
    end
    add_index :blacklists, :twitter_verified_user_id
  end
end
