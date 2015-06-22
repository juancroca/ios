FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    semester {Course::SEMESTER[Random.rand(2)]}
    year {2000 + Random.rand(10)}
    sequence(:isis_id) { |n| n }

    transient do
      supervisor_count 1
    end
    after(:create) do |course, evaluator|
      (1..evaluator.supervisor_count).each  do
        supervisor = create(:supervisor)
        course.supervisors << supervisor
      end
    end

    trait :with_groups do
      transient do
        groups_count 5
      end
      after(:create) do |course, evaluator|
        create_list(:group, evaluator.groups_count, :with_associations, course: course)
      end
    end

    trait :with_skills do
      transient do
        skill_count 5
      end
      after(:create) do |course, evaluator|
        (1..evaluator.skill_count).each do
          course.skills << create(:skill)
        end
      end
    end

    trait :with_registrations do
      transient do
        registration_count 5
      end
      after(:create) do |course, evaluator|
        create_list(:registration, evaluator.registration_count, :with_associations, course_id: course.id)
      end
    end

    trait :with_preferences do
      preferences {{groups: true, friends: true, diverse: true, compulsory: true}}
    end

    trait :visible do
      visible true
    end

    trait :with_associations do
      with_groups
      with_skills
      with_registrations
      visible
    end
  end
end
