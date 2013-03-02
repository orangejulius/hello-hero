class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, :null => false, :default => false

    User.create! do |r|
      r.email      = 'admin@hellohero.co'
      r.password   = 'password'
      r.admin      = true
    end
  end
end
