FactoryGirl.define do
  factory :review do
    course_id 1
    professor_id 1

    professor_rating 3
    enjoyability 3
    difficulty 3
    recommend 3

    factory :review_with_user do
      user_id 1
    end
  end
end