class AddWeightsToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :weight, :integer, default: 0
  end
end
