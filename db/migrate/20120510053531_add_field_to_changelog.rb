class AddFieldToChangelog < ActiveRecord::Migration
  def change
    add_column :change_logs, :field, :string, :null => false, :default => ''
  end
end
