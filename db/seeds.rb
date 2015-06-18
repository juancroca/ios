require 'factory_girl_rails'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
FactoryGirl.create :course, :with_associations, :with_preferences, isis_id: 5036
FactoryGirl.create_list :course, 10, :with_associations
