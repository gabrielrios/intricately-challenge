FactoryBot.define do
  factory :hostname do
    sequence(:hostname) { |n| "host#{n}.com" }
  end
end
