class RenameWaitingListFromGroup < ActiveRecord::Migration
  def change
    rename_column :groups, :waitingList, :waiting_list
  end
end
