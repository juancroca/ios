class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :course
      t.boolean :started, default: false
      t.boolean :completed, default: false
      t.timestamps null: false
    end
  end
end
