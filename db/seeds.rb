require 'factory_girl_rails'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
#FactoryGirl.create :course, :with_associations, :with_preferences, isis_id: 1
#FactoryGirl.create_list :course, 10, :with_associations

seed_file = Rails.root.join('db', 'skills.yml')
skills = YAML::load_file(seed_file)
counter = 0
skills.each do |skill|
	Skill.create!(:name => skill) do |n|
	  puts "Create skill #{counter += 1} with name: #{skill}"
	end
end