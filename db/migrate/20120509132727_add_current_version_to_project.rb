class AddCurrentVersionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :current_version_id, :integer
  end
end
