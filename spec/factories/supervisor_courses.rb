FactoryGirl.define do
  factory :supervisor_course do
    association :supervisor, :course
  end

end
