class AddPriorityToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :priority, :integer, :default => 5
  end
end
