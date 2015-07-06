class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :job
      t.references :group
      t.references :user
      t.timestamps null: false
    end
  end
end
