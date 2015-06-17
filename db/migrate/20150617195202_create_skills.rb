class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name, index: true
      t.timestamps null: false
    end
  end

  def data
    skills = YAML.load_file("db/skills.yml")
    Skill.create(skills.map{|s| {name: s}})
  end
end
