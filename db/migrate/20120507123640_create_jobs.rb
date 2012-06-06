class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer  :project_id
      t.string   :title,              :null => false
      t.integer  :charge_id
      t.integer  :user_id
      t.integer  :expected_time
      t.datetime :expected_finish_at
      t.text     :description
      t.string   :type
      t.string   :status
      t.integer  :version_id
      t.boolean  :closed,             :default => false

      t.timestamps
    end
  end
end
