class CreateRelavants < ActiveRecord::Migration
  def change
    create_table :relavants do |t|
      t.integer :job_id
      t.integer :user_id

      t.timestamps
    end
  end
end
