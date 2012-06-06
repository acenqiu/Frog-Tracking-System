class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :project_id
      t.integer :user_id
      t.string  :role,         :null => false      
      t.string  :position
      t.boolean :should_audit, :default => true

      t.timestamps
    end
  end
end
