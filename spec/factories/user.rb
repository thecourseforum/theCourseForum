# This will guess the User class
FactoryGirl.define do
  factory :user do
    factory :confirmed_user_with_student do
      first_name "John"
      last_name  "Doe"
      email "email@virginia.edu"
      password "password"
      password_confirmation "password"
      confirmed_at Time.now

      after(:create) do |user, evaluator|
        create_list(:student, 1, user: user)
      end
    end
  end
end