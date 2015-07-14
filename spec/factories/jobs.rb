FactoryGirl.define do
  factory :job do
    selected true
    transient do
      result_count 5
    end
    after(:create) do |job, evaluator|
      (1..evaluator.result_count).each  do
        result = create(:result)
        job.results << result
      end
    end
  end

end
