class AddSelectedToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :selected, :boolean, default: false
  end
end
