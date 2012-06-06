class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer  :project_id
      t.string   :version,     :null => false
      t.string   :description
      t.datetime :start_at
      t.datetime :end_at
      t.text     :release_note
      t.datetime :release_at

      t.timestamps
    end
  end
end
