class AddFieldsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :mandatory, :boolean, default: false
    add_column :groups, :weight, :integer, default: 0
  end
end
