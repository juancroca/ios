FactoryGirl.define do
  factory :registration do
    association :student
    association :course

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

    trait :with_friends do
      transient do
        friends_count 5
      end
      before(:create) do |registration, evaluator|
        students = registration.course.students
        friends_count = evaluator.friends_count
        friends_count = students.count if students.count < friends_count
        registration.friend_ids = registration.course.students.first(friends_count).map(&:id)
      end
    end

    trait :with_groups do
      before(:create) do |registration, evaluator|
        registration.course.groups.ids.each do |id|
          registration.groups[id.to_s] = Random.rand(11)
        end
      end
    end

    trait :with_associations do
      with_skill_scores
      with_friends
      with_groups
    end
  end

end
