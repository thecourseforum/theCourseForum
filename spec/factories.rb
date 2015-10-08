FactoryGirl.define do

  factory :user do
    email 'aw3as@virginia.edu'
    first_name 'Alan'
    password 'password'
    password_confirmation 'password'
    factory :confirmed_user do
      after(:create) do |user| 
        user.confirm!
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
      student.majors << major
    end
  end

  factory :major do
    name 'Computer Science'
  end

  factory :school do
    name 'School of Engineering & Applied Science'
  end

  factory :department do
    association :school
    name 'Computer Science'
  end

  factory :subdepartment do
    name 'Computer Science'
    mnemonic 'CS'
    after(:create) do |subdepartment|
      department = create :department
      department.subdepartments << subdepartment
    end
  end

  factory :professor do
    first_name 'Aaron'
    last_name 'Bloomfield'
  end

  factory :semester do
    number 1158
    season 'Fall'
    year 2015
  end

  factory :section do
    sis_class_number 16936
    section_number 1
    units 3
    association :course
    association :semester
  end

  factory :section_professor do
    association :section
    association :professor
  end

  factory :course do
    title 'Program and Data Representation'
    course_number 2150
    association :subdepartment
  end
end