FactoryGirl.define do
  factory :skill_score do
    score {Random.rand(10)+1}
    association :registration, :skill
  end

end
