class CreateChangeLogs < ActiveRecord::Migration
  def change
    create_table :change_logs do |t|
      t.integer :job_id
      t.integer :user_id
      t.string  :from,   :null => false
      t.string  :to,     :null => false
      t.string  :reason

      t.timestamps
    end
  end
end
