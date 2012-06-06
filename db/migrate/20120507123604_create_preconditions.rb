class CreatePreconditions < ActiveRecord::Migration
  def change
    create_table :preconditions do |t|
      t.integer :job_id
      t.integer :prejob_id

      t.timestamps
    end
  end
end
