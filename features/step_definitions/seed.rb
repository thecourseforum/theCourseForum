Given /^courses exist$/ do
  if Course.count == 0
    school = School.create(:name => 'School of Engineering & Applied Science')
    department = Department.create(:school => school, :name => 'Computer Science')
    subdepartment = Subdepartment.create(:name => 'Computer Science', :mnemonic => 'CS')
    lastest_semester = Semester.create(:number => 1168, :season => 'Fall', :year => 2016)
    older_semester = Semester.create(:number => 1162, :season => 'Spring', :year => 2016)
    department.subdepartments << subdepartment
    course = Course.create(
      :title => 'Program and Data Representation',
      :course_number => 2150,
      :subdepartment => subdepartment,
      :last_taught_semester => lastest_semester
    )
    
    bloomfield = Professor.create(:first_name => 'Aaron', :last_name => 'Bloomfield')
    martin = Professor.create(:first_name => 'Worthy', :last_name => 'Martin')
    floryan = Professor.create(:first_name => 'Mark', :last_name => 'Floryan')
    elzinga = Professor.create(:first_name => 'Kenneth', :last_name => 'Elzinga')

    first_section = Section.create(
      :sis_class_number => 17471,
      :section_number => 1,
      :units => 3,
      :course => course,
      :semester => lastest_semester
    )
    second_section = Section.create(
      :sis_class_number => 16937,
      :section_number => 2,
      :units => 3,
      :course => course,
      :semester => lastest_semester
    )
    third_section = Section.create(
      :sis_class_number => 16937,
      :section_number => 2,
      :units => 3,
      :course => course,
      :semester => older_semester
    )
    SectionProfessor.create(
      :section => first_section,
      :professor => bloomfield
    )
    SectionProfessor.create(
      :section => second_section,
      :professor => floryan
    )
    SectionProfessor.create(
      :section => first_section,
      :professor => bloomfield
    )
  end
end

Given /^a review exists$/ do
  if Review.count == 0
    step 'courses exist'
    Review.create(
      :comment => 'Sample Text Here',
      :student_id => User.first.id,
      :course => Course.first,
      :professor => Professor.first,
      :semester => Semester.first,
      :professor_rating => 2,
      :enjoyability => 2,
      :difficulty => 2,
      :recommend => 2
    )
  end
end