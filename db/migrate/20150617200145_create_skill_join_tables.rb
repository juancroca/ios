class CreateSkillJoinTables < ActiveRecord::Migration
  def change
    create_table :skill_scores do |t|
      t.belongs_to :registration, index: true, foreign_key: true
      t.belongs_to :skill, index: true, foreign_key: true
      t.integer :score, default: 0

      t.timestamps null: false
    end

    create_table :courses_skills do |t|
      t.belongs_to :course, index: true
      t.belongs_to :skill, index: true
    end

    create_table :groups_skills do |t|
      t.belongs_to :group, index: true
      t.belongs_to :skill, index: true
    end
  end
end
