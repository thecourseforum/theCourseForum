FactoryGirl.define do

  factory :user do
    email 'aw3as@virginia.edu'
    first_name 'Alan'
    password 'password'
    password_confirmation 'password'
    factory :confirmed_user do
      after(:create) do |user| 
        user.confirm
      end
    end
  end

  factory :student do
    grad_year '2017'
    association :user, :factory => :confirmed_user
    after(:create) do |student|   
      major = Major.find_by(:name => 'Computer Science')
      unless major
        major = create :major
      end
      student.student_majors.create(:major => major)
    end
  end

  factory :major do
    name 'Computer Science'
  end
  
end