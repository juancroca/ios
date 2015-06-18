require 'factory_girl_rails'

# include local factories
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each do |f|
  fp =  File.expand_path(f)
  require fp
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
