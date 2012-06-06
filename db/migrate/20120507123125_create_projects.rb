class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string  :name,      :null => false, :limit => 32
      t.text    :description
      t.boolean :active,    :default => true

      t.timestamps
    end
  end
end
