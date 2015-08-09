FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Group #{n}" }
    minsize 1
    maxsize 10
    waiting_list false
    association :course

    trait :with_skills do
      transient do
        skill_count 5
      end
      after(:create) do |group, evaluator|
        (1..evaluator.skill_count).each  do
          group.skills << create(:skill)
        end
      end
    end

    trait :with_students do
    end

    trait :with_associations do
      with_skills
      with_students
    end
  end

end
