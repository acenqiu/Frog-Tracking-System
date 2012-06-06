class RenameExpectedFinishAtToStartAt < ActiveRecord::Migration

  def change
  	rename_column :jobs, :expected_finish_at, :expected_start_at
  end
end
