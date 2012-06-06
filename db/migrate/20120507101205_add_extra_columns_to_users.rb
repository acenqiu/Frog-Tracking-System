class AddExtraColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :username,          :string,  :limit => 20
    add_column :users, :telephone,         :string,  :limit => 20
    add_column :users, :token,             :string,  :limit => 32
    add_column :users, :active,            :boolean, :default => true
  end
end
