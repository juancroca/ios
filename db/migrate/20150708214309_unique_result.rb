class UniqueResult < ActiveRecord::Migration
  def change
    add_index :results, [:user_id, :job_id], unique: true
  end
end
