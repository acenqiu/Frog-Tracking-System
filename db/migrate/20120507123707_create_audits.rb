class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.integer :job_id
      t.integer :user_id
      t.string  :result
      t.string  :note

      t.timestamps
    end
  end
end
