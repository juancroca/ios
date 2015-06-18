FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:name) { |n| "Person #{n}" }

    factory :supervisor do
      sequence(:email) { |n| "supervisor#{n}@example.com" }
      sequence(:name) { |n| "Supervisor #{n}" }
    end

    factory :student do
      sequence(:email) { |n| "student#{n}@example.com" }
      sequence(:name) { |n| "Student #{n}" }
    end
  end

end
