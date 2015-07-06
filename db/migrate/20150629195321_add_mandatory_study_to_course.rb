class AddMandatoryStudyToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :study_fields, :text
  end
end
