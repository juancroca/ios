class AddRemoveFields < ActiveRecord::Migration
  def change
    remove_column :groups, :weight, :integer, default: 0
    remove_column :registrations, :compulsory, :boolean
    add_column   :registrations, :study_field, :string
  end
end
