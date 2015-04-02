# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150401202146) do

  create_table "book_requirements", id: false, force: true do |t|
    t.integer "section_id"
    t.integer "book_id"
    t.text    "requirement_status"
  end

  create_table "books", force: true do |t|
    t.text    "title"
    t.text    "author"
    t.integer "ISBN",                limit: 8
    t.text    "binding"
    t.boolean "new_availability"
    t.boolean "used_availability"
    t.boolean "rental_availability"
    t.text    "new_price"
    t.text    "new_rental_price"
    t.text    "used_price"
    t.text    "used_rental_price"
    t.text    "signed_request"
    t.text    "ASIN"
    t.text    "details_page"
    t.text    "small_image_URL"
    t.text    "medium_image_URL"
    t.integer "amazon_new_price"
    t.text    "affiliate_link"
  end

  add_index "books", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "bugs", force: true do |t|
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "calendar_sections", force: true do |t|
    t.integer "section_id"
    t.integer "user_id"
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.decimal  "course_number",    precision: 4, scale: 0, default: 0
    t.integer  "subdepartment_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "title_changed"
  end

  add_index "courses", ["subdepartment_id"], name: "index_courses_on_subdepartment_id", using: :btree

  create_table "courses_users", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "courses_users", ["user_id", "course_id"], name: "index_courses_users_on_user_id_and_course_id", unique: true, using: :btree

  create_table "day_times", force: true do |t|
    t.string   "day"
    t.string   "start_time"
    t.string   "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_times_sections", id: false, force: true do |t|
    t.integer "day_time_id"
    t.integer "section_id"
    t.integer "location_id"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "departments", ["school_id"], name: "index_departments_on_school_id", using: :btree

  create_table "departments_subdepartments", id: false, force: true do |t|
    t.integer "department_id"
    t.integer "subdepartment_id"
  end

  create_table "grades", force: true do |t|
    t.integer  "section_id"
    t.integer  "semester_id"
    t.decimal  "gpa",            precision: 4, scale: 3, default: 0.0
    t.integer  "count_a"
    t.integer  "count_aminus"
    t.integer  "count_bplus"
    t.integer  "count_b"
    t.integer  "count_bminus"
    t.integer  "count_cplus"
    t.integer  "count_c"
    t.integer  "count_cminus"
    t.integer  "count_dplus"
    t.integer  "count_d"
    t.integer  "count_dminus"
    t.integer  "count_f"
    t.integer  "count_drop"
    t.integer  "count_withdraw"
    t.integer  "count_other"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "count_aplus"
    t.integer  "total"
  end

  add_index "grades", ["section_id"], name: "index_grades_on_CourseProfessor_id", using: :btree
  add_index "grades", ["semester_id"], name: "index_grades_on_semester_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lou_sections1098", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1101", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1102", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1106", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1108", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1111", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1112", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1116", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1118", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1121", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1122", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1126", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1128", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1131", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1132", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1136", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1138", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1141", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1142", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1146", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1148", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1151", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "lou_sections1152", id: false, force: true do |t|
    t.integer "sisID"
    t.integer "sectionNumber"
    t.string  "subdepartment"
    t.string  "courseName"
    t.string  "units"
    t.integer "capacity"
    t.integer "course_semester_id"
    t.string  "sectionType"
    t.string  "mnemonic"
    t.integer "courseNumber"
    t.string  "professor"
    t.string  "professor_alias"
    t.string  "scheduleTime"
    t.string  "place"
    t.string  "sectionLeader"
    t.string  "sectionTime"
    t.string  "sectionLocation"
    t.string  "topic"
    t.integer "enrollment"
  end

  create_table "majors", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professor_salary", force: true do |t|
    t.text    "staff_type"
    t.text    "assignment_organization"
    t.integer "annual_salary"
    t.integer "normal_hours"
    t.text    "working_title"
  end

  add_index "professor_salary", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "professors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "preferred_name"
    t.string   "email_alias"
    t.integer  "department_id"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "middle_name"
    t.text     "classification"
    t.text     "department"
    t.text     "department_code"
    t.text     "primary_email"
    t.text     "office_phone"
    t.text     "office_address"
    t.text     "registered_email"
    t.text     "fax_phone"
    t.text     "title"
    t.text     "home_phone"
    t.text     "home_page"
    t.text     "mobile_phone"
    t.integer  "professor_salary_id"
  end

  add_index "professors", ["department_id"], name: "index_professors_on_department_id", using: :btree
  add_index "professors", ["user_id"], name: "index_professors_on_user_id", using: :btree

  create_table "reviews", force: true do |t|
    t.text     "comment"
    t.integer  "course_professor_id"
    t.integer  "student_id"
    t.integer  "semester_id"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.decimal  "professor_rating",    precision: 11, scale: 2, default: 0.0
    t.integer  "enjoyability",                                 default: 0
    t.integer  "difficulty",                                   default: 0
    t.decimal  "amount_reading",      precision: 11, scale: 2, default: 0.0
    t.decimal  "amount_writing",      precision: 11, scale: 2, default: 0.0
    t.decimal  "amount_group",        precision: 11, scale: 2, default: 0.0
    t.decimal  "amount_homework",     precision: 11, scale: 2, default: 0.0
    t.boolean  "only_tests",                                   default: false
    t.integer  "recommend",                                    default: 0
    t.string   "ta_name"
    t.integer  "course_id"
    t.integer  "professor_id"
  end

  add_index "reviews", ["course_professor_id"], name: "index_reviews_on_CourseProfessor_id", using: :btree
  add_index "reviews", ["semester_id"], name: "index_reviews_on_semester_id", using: :btree
  add_index "reviews", ["student_id"], name: "index_reviews_on_student_id", using: :btree

  create_table "schedules", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "website"
  end

  create_table "section_professors", force: true do |t|
    t.integer  "section_id"
    t.integer  "professor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "section_professors", ["professor_id"], name: "index_section_professors_on_professor_id", using: :btree
  add_index "section_professors", ["section_id"], name: "index_section_professors_on_section_id", using: :btree

  create_table "sections", force: true do |t|
    t.integer  "sis_class_number"
    t.integer  "section_number"
    t.string   "topic"
    t.string   "units"
    t.integer  "capacity"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "section_type"
    t.integer  "course_id"
    t.integer  "semester_id"
  end

  create_table "sections_users", id: false, force: true do |t|
    t.integer "section_id"
    t.integer "user_id"
  end

  add_index "sections_users", ["user_id", "section_id"], name: "index_sections_users_on_user_id_and_section_id", unique: true, using: :btree

  create_table "semesters", force: true do |t|
    t.integer  "number"
    t.string   "season"
    t.decimal  "year",       precision: 4, scale: 0, default: 0
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "settings", force: true do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "student_majors", force: true do |t|
    t.integer  "student_id"
    t.integer  "major_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "student_majors", ["major_id"], name: "index_student_majors_on_major_id", using: :btree
  add_index "student_majors", ["student_id"], name: "index_student_majors_on_student_id", using: :btree

  create_table "students", force: true do |t|
    t.decimal  "grad_year",  precision: 4, scale: 0, default: 0
    t.integer  "user_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "subdepartments", force: true do |t|
    t.string   "name"
    t.string   "mnemonic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "old_password"
    t.integer  "student_id"
    t.integer  "professor_id"
    t.boolean  "subscribed_to_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["professor_id"], name: "index_users_on_professor_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["student_id"], name: "index_users_on_student_id", using: :btree

  create_table "votes", force: true do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
