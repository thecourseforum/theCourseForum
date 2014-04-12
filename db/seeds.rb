# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(
  email: "mst3k@virginia.edu", 
  password: "foobarbaz", 
  password_confirmation: "foobarbaz",
  first_name: "Mystery",
  last_name: "Theater",
  confirmed_at: Time.now)

student = Student.create(
  grad_year: 2014,
  user_id: user.id)

majors = Major.create([
  {name: "Computer Science"},
  {name: "Architecture"},
  {name: "English"},
  {name: "SWAG"}
])

schools = School.create([
  {name: "College of Arts & Sciences"},
  {name: "School of Engineering & Applied Science"},
  {name: "Other Schools"}
])

departments = Department.create([
  {name: "Politics", school_id: 1},
  {name: "Computer Science", school_id: 2},
  {name: "School of Architecture", school_id: 3},
  {name: "Electrical Engineering", school_id: 2},
  {name: "Psychology", school_id: 1},
  {name: "Univeristy Seminar", school_id: 3}
])

subdepartments = Subdepartment.create([
  {name: "Politics-American Politics", mnemonic: "PLAP"},
  {name: "Computer Science", mnemonic: "CS"},
  {name: "Architecture", mnemonic: "ARCH"},
  {name: "Electrical Engineering", mnemonic: "EE"},
  {name: "Psychology", mnemonic: "PSYC"},
  {name: "University Seminar", mnemonic: "USEM"}
])

departments[0].subdepartments = [subdepartments[0]]
departments[1].subdepartments = [subdepartments[1]]
departments[2].subdepartments = [subdepartments[2]]
departments[3].subdepartments = [subdepartments[3]]
departments[4].subdepartments = [subdepartments[4]]
departments[5].subdepartments = [subdepartments[5]]

courses = Course.create([
  {title: "Intro to Programming", course_number: 1110, subdepartment_id: 2},
  {title: "Programming and Data Representation", course_number: 2150, subdepartment_id: 2},
  {title: "Software Development Tools", course_number: 2110, subdepartment_id: 2},
  {title: "Introduction to American Politics", course_number: 1010, subdepartment_id: 1},
  {title: "Lessons of the Lawn", course_number: 1010, subdepartment_id: 3},
  {title: "Lessons in Making", course_number: 1020, subdepartment_id: 3}
])

professors = Professor.create([
  {first_name: "Mark", last_name: "Sherriff", email_alias: "mss2x"},
  {first_name: "Aaron", last_name: "Bloomfield", email_alias: "asb2t"},
  {first_name: "Tom", last_name: "Horton", email_alias: "tbh3f"},
  {first_name: "Larry", last_name: "Sabato", email_alias: "ljs"},
  {first_name: "Peter", last_name: "Waldman", email_alias: "pdw7e"},
  {first_name: "Sanda", last_name: "Iliescu", email_alias: "sdi5h"}
])

course_semesters = CourseSemester.create([
  {course_id: 1, semester_id: 1},
  {course_id: 2, semester_id: 1},
  {course_id: 3, semester_id: 1},
  {course_id: 4, semester_id: 1},
  {course_id: 5, semester_id: 1},
  {course_id: 6, semester_id: 1}
])

sections = Section.create([
  {course_semester_id: 1},
  {course_semester_id: 2},
  {course_semester_id: 3},
  {course_semester_id: 4},
  {course_semester_id: 5},
  {course_semester_id: 6}
])

section_professors = SectionProfessor.create([
  {section_id: 1, professor_id: 1},
  {section_id: 2, professor_id: 2},
  {section_id: 3, professor_id: 3},
  {section_id: 4, professor_id: 4},
  {section_id: 5, professor_id: 5},
  {section_id: 6, professor_id: 6}
])

semesters = Semester.create([
  {number: 1148, season: "Fall", year: 2014}
])

reviews = Review.create([
  {course_id: 1, professor_id: 1, semester_id: 1, student_id: 1, 
    professor_rating: 4.0, enjoyability: 5, difficulty: 3, recommend: 4,
    amount_reading: 2.0,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum posuere justo eget blandit dictum. Etiam mattis tellus vel fermentum molestie. Sed sed porttitor lacus. Donec quis varius est. Ut sed pretium lorem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec accumsan nunc eu risus elementum convallis. Vestibulum lobortis, nulla sit amet consequat cursus, eros lacus ultricies lacus, id tincidunt massa eros et tellus. Mauris ultrices odio nec nulla congue faucibus. Pellentesque pharetra convallis purus, nec tincidunt sapien viverra sed. Sed sit amet volutpat nisi. Phasellus tincidunt lectus id tincidunt lobortis. Mauris ut ipsum vulputate, convallis ipsum vitae, tempor erat. Morbi suscipit nec odio vitae imperdiet."},
  {course_id: 2, professor_id: 2, semester_id: 1, student_id: 1, 
    professor_rating: 4.0, enjoyability: 5, difficulty: 3, recommend: 4,
    amount_reading: 2.0,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum dui et posuere lobortis. Aenean congue lectus sit amet arcu luctus, vel molestie odio tempor. Integer vitae semper est. Aenean semper leo in dolor elementum, sit amet convallis diam fringilla. Ut a feugiat turpis, quis aliquet nibh. Vivamus quis facilisis libero, ac accumsan dui. Aenean magna turpis, porta vel porttitor id, feugiat in tortor. Donec euismod non sapien sed convallis."},
  {course_id: 3, professor_id: 3, semester_id: 1, student_id: 1, 
    professor_rating: 4.0, enjoyability: 5, difficulty: 3, recommend: 4,
    amount_reading: 2.0,
    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec fermentum dui et posuere lobortis. Aenean congue lectus sit amet arcu luctus, vel molestie odio tempor. Integer vitae semper est. Aenean semper leo in dolor elementum, sit amet convallis diam fringilla. Ut a feugiat turpis, quis aliquet nibh. Vivamus quis facilisis libero, ac accumsan dui. Aenean magna turpis, porta vel porttitor id, feugiat in tortor. Donec euismod non sapien sed convallis."}
])

sections = Section.create([
  {sis_class_number: 1, section_number: 1, units: "3", capacity: 60, section_type: "Discussion"},
  {sis_class_number: 2, section_number: 2, units: "3", capacity: 100, section_type: "Discussion"},
  {sis_class_number: 3, section_number: 3, units: "2", capacity: 30, section_type: "Discussion"},
  {sis_class_number: 4, section_number: 1, units: "3", capacity: 20, section_type: "Discussion"}
])

day_times = DayTime.create([
  {days: "MoWeFr", start_time: "10:00", end_time: "10:50"},
  {days: "MoWeFr", start_time: "11:00", end_time: "11:50"},
  {days: "TuTh", start_time: "9:30", end_time: "10:45"},
  {days: "TuTh", start_time: "14:00", end_time: "15:15"},
  {days: "Th", start_time: "8:30", end_time: "9:20"}
])

locations = Location.create([
  {location: "Olsson Hall 120"},
  {location: "Rice Hall 130"},
  {location: "Old Cabel Hall 005"},
  {location: "Glimer Hall 130"},
  {location: "Chemistry Bldg 402"}
])