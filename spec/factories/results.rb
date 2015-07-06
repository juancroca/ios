FactoryGirl.define do
  factory :result do
    association :user
    association :group
  end
end
