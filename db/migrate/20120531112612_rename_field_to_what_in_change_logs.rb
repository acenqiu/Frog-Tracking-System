class RenameFieldToWhatInChangeLogs < ActiveRecord::Migration
  def change
  	rename_column :change_logs, :field, :what
  end
end
