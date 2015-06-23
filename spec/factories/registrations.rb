FactoryGirl.define do
  factory :registration do
    association :student
    association :course

    trait :is_required do
      compulsory true
    end

    trait :not_required do
      compulsory false
    end

    trait :with_skill_scores do
      transient do
        skill_score_count 5
      end
      after(:create) do |registration, evaluator|
        skills = registration.course.groups.map(&:skills).flatten
        if skills.empty?
          (1..evaluator.skill_score_count).each  do
            skill = create(:skill)
            create(:skill_score, registration: registration, skill: skill)
          end
        else
          skills.each do |skill|
            create(:skill_score, registration: registration, skill: skill)
          end
        end
      end
    end

    trait :with_associations do
      with_skill_scores
    end
  end

end
