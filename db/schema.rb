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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130301004449) do

  create_table "course_professors", :force => true do |t|
    t.integer  "course_id"
    t.integer  "professor_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "course_professors", ["course_id"], :name => "index_course_professors_on_course_id"
  add_index "course_professors", ["professor_id"], :name => "index_course_professors_on_professor_id"

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.decimal  "course_number",    :precision => 10, :scale => 0
    t.integer  "subdepartment_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "courses", ["subdepartment_id"], :name => "index_courses_on_subdepartment_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "departments", ["school_id"], :name => "index_departments_on_school_id"

  create_table "grades", :force => true do |t|
    t.integer  "CourseProfessor_id"
    t.integer  "semester_id"
    t.decimal  "gpa",                :precision => 10, :scale => 0
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
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "grades", ["CourseProfessor_id"], :name => "index_grades_on_CourseProfessor_id"
  add_index "grades", ["semester_id"], :name => "index_grades_on_semester_id"

  create_table "majors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "professors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "preferred_name"
    t.string   "email_alias"
    t.integer  "department_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "professors", ["department_id"], :name => "index_professors_on_department_id"
  add_index "professors", ["user_id"], :name => "index_professors_on_user_id"

  create_table "reviews", :force => true do |t|
    t.text     "comment"
    t.integer  "CourseProfessor_id"
    t.integer  "student_id"
    t.integer  "semester_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "reviews", ["CourseProfessor_id"], :name => "index_reviews_on_CourseProfessor_id"
  add_index "reviews", ["semester_id"], :name => "index_reviews_on_semester_id"
  add_index "reviews", ["student_id"], :name => "index_reviews_on_student_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "website"
  end

  create_table "semesters", :force => true do |t|
    t.integer  "number"
    t.string   "season"
    t.decimal  "year",       :precision => 10, :scale => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "student_majors", :force => true do |t|
    t.integer  "student_id"
    t.integer  "major_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "student_majors", ["major_id"], :name => "index_student_majors_on_major_id"
  add_index "student_majors", ["student_id"], :name => "index_student_majors_on_student_id"

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.decimal  "grad_year",  :precision => 10, :scale => 0
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "subdepartments", :force => true do |t|
    t.string   "name"
    t.string   "mnemonic"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "subdepartments", ["department_id"], :name => "index_subdepartments_on_department_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_crypt"
    t.string   "old_password"
    t.integer  "student_id"
    t.integer  "professor_id"
    t.datetime "last_login"
    t.boolean  "subscribed_to_email"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "users", ["professor_id"], :name => "index_users_on_professor_id"
  add_index "users", ["student_id"], :name => "index_users_on_student_id"

end
