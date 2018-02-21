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

ActiveRecord::Schema.define(version: 20161210164918) do

  create_table "book_requirements", force: :cascade do |t|
    t.integer "section_id", limit: 4,   null: false
    t.integer "book_id",    limit: 4,   null: false
    t.string  "status",     limit: 255, null: false
  end

  add_index "book_requirements", ["book_id", "section_id"], name: "index_book_requirements_on_book_id_and_section_id", unique: true, using: :btree

  create_table "books", force: :cascade do |t|
    t.string  "title",                      limit: 255
    t.string  "author",                     limit: 255
    t.string  "publisher",                  limit: 255
    t.string  "edition",                    limit: 255
    t.string  "binding",                    limit: 255
    t.string  "isbn",                       limit: 255
    t.float   "bookstore_new_price",        limit: 24
    t.float   "bookstore_used_price",       limit: 24
    t.text    "asin",                       limit: 65535
    t.text    "small_image_link",           limit: 65535
    t.text    "medium_image_link",          limit: 65535
    t.text    "large_image_link",           limit: 65535
    t.float   "amazon_official_new_price",  limit: 24
    t.float   "amazon_official_used_price", limit: 24
    t.float   "amazon_merchant_new_price",  limit: 24
    t.float   "amazon_merchant_used_price", limit: 24
    t.integer "amazon_new_total",           limit: 4
    t.integer "amazon_used_total",          limit: 4
    t.text    "amazon_affiliate_link",      limit: 65535
  end

  add_index "books", ["isbn"], name: "index_books_on_isbn", unique: true, using: :btree

  create_table "books_users", id: false, force: :cascade do |t|
    t.integer "book_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
  end

  add_index "books_users", ["book_id", "user_id"], name: "index_books_users_on_book_id_and_user_id", unique: true, using: :btree

  create_table "bugs", force: :cascade do |t|
    t.string   "url",         limit: 255
    t.text     "description", limit: 65535
    t.string   "email",       limit: 255
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendar_sections", force: :cascade do |t|
    t.integer "section_id", limit: 4
    t.integer "user_id",    limit: 4
  end

  create_table "courses", force: :cascade do |t|
    t.string   "title",                   limit: 255
    t.text     "description",             limit: 65535
    t.decimal  "course_number",                         precision: 4, default: 0
    t.integer  "subdepartment_id",        limit: 4
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.boolean  "title_changed"
    t.integer  "last_taught_semester_id", limit: 4
  end

  add_index "courses", ["subdepartment_id"], name: "index_courses_on_subdepartment_id", using: :btree

  create_table "courses_users", id: false, force: :cascade do |t|
    t.integer "course_id", limit: 4
    t.integer "user_id",   limit: 4
  end

  add_index "courses_users", ["user_id", "course_id"], name: "index_courses_users_on_user_id_and_course_id", unique: true, using: :btree

  create_table "day_times", force: :cascade do |t|
    t.string   "day",        limit: 255
    t.string   "start_time", limit: 255
    t.string   "end_time",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_times_sections", force: :cascade do |t|
    t.integer "day_time_id", limit: 4
    t.integer "section_id",  limit: 4
    t.integer "location_id", limit: 4
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "school_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "departments", ["school_id"], name: "index_departments_on_school_id", using: :btree

  create_table "departments_subdepartments", id: false, force: :cascade do |t|
    t.integer "department_id",    limit: 4
    t.integer "subdepartment_id", limit: 4
  end

  create_table "grades", force: :cascade do |t|
    t.integer  "section_id",     limit: 4
    t.integer  "semester_id",    limit: 4
    t.decimal  "gpa",                      precision: 4, scale: 3, default: 0.0
    t.integer  "count_a",        limit: 4
    t.integer  "count_aminus",   limit: 4
    t.integer  "count_bplus",    limit: 4
    t.integer  "count_b",        limit: 4
    t.integer  "count_bminus",   limit: 4
    t.integer  "count_cplus",    limit: 4
    t.integer  "count_c",        limit: 4
    t.integer  "count_cminus",   limit: 4
    t.integer  "count_dplus",    limit: 4
    t.integer  "count_d",        limit: 4
    t.integer  "count_dminus",   limit: 4
    t.integer  "count_f",        limit: 4
    t.integer  "count_drop",     limit: 4
    t.integer  "count_withdraw", limit: 4
    t.integer  "count_other",    limit: 4
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "count_aplus",    limit: 4
    t.integer  "total",          limit: 4
  end

  add_index "grades", ["section_id"], name: "index_grades_on_CourseProfessor_id", using: :btree
  add_index "grades", ["semester_id"], name: "index_grades_on_semester_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "location",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "majors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "professor_salary", force: :cascade do |t|
    t.text    "staff_type",              limit: 65535
    t.text    "assignment_organization", limit: 65535
    t.integer "annual_salary",           limit: 4
    t.integer "normal_hours",            limit: 4
    t.text    "working_title",           limit: 65535
  end

  add_index "professor_salary", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "professors", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "preferred_name",      limit: 255
    t.string   "email_alias",         limit: 255
    t.integer  "department_id",       limit: 4
    t.integer  "user_id",             limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "middle_name",         limit: 255
    t.text     "classification",      limit: 65535
    t.text     "department",          limit: 65535
    t.text     "department_code",     limit: 65535
    t.text     "primary_email",       limit: 65535
    t.text     "office_phone",        limit: 65535
    t.text     "office_address",      limit: 65535
    t.text     "registered_email",    limit: 65535
    t.text     "fax_phone",           limit: 65535
    t.text     "title",               limit: 65535
    t.text     "home_phone",          limit: 65535
    t.text     "home_page",           limit: 65535
    t.text     "mobile_phone",        limit: 65535
    t.integer  "professor_salary_id", limit: 4
  end

  add_index "professors", ["department_id"], name: "index_professors_on_department_id", using: :btree
  add_index "professors", ["user_id"], name: "index_professors_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.text     "comment",             limit: 65535
    t.integer  "course_professor_id", limit: 4
    t.integer  "student_id",          limit: 4
    t.integer  "semester_id",         limit: 4
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.decimal  "professor_rating",                  precision: 11, scale: 2, default: 0.0
    t.integer  "enjoyability",        limit: 4,                              default: 0
    t.integer  "difficulty",          limit: 4,                              default: 0
    t.decimal  "amount_reading",                    precision: 11, scale: 2, default: 0.0
    t.decimal  "amount_writing",                    precision: 11, scale: 2, default: 0.0
    t.decimal  "amount_group",                      precision: 11, scale: 2, default: 0.0
    t.decimal  "amount_homework",                   precision: 11, scale: 2, default: 0.0
    t.boolean  "only_tests",                                                 default: false
    t.integer  "recommend",           limit: 4,                              default: 0
    t.string   "ta_name",             limit: 255
    t.integer  "course_id",           limit: 4
    t.integer  "professor_id",        limit: 4
    t.boolean  "deleted",                                                    default: false, null: false
  end

  add_index "reviews", ["course_professor_id"], name: "index_reviews_on_CourseProfessor_id", using: :btree
  add_index "reviews", ["semester_id"], name: "index_reviews_on_semester_id", using: :btree
  add_index "reviews", ["student_id"], name: "index_reviews_on_student_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.boolean  "flagged"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules_sections", id: false, force: :cascade do |t|
    t.integer "schedule_id", limit: 4, null: false
    t.integer "section_id",  limit: 4, null: false
  end

  add_index "schedules_sections", ["schedule_id", "section_id"], name: "index_schedules_sections_on_schedule_id_and_section_id", unique: true, using: :btree

  create_table "schools", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "website",    limit: 255
  end

  create_table "section_professors", force: :cascade do |t|
    t.integer  "section_id",   limit: 4
    t.integer  "professor_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "section_professors", ["professor_id"], name: "index_section_professors_on_professor_id", using: :btree
  add_index "section_professors", ["section_id"], name: "index_section_professors_on_section_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.integer  "sis_class_number", limit: 4
    t.integer  "section_number",   limit: 4
    t.string   "topic",            limit: 255
    t.string   "units",            limit: 255
    t.integer  "capacity",         limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "section_type",     limit: 255
    t.integer  "course_id",        limit: 4
    t.integer  "semester_id",      limit: 4
  end

  create_table "semesters", force: :cascade do |t|
    t.integer  "number",     limit: 4
    t.string   "season",     limit: 255
    t.decimal  "year",                   precision: 4, default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",         limit: 255,   null: false
    t.text     "value",       limit: 65535
    t.integer  "target_id",   limit: 4,     null: false
    t.string   "target_type", limit: 255,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "stats", force: :cascade do |t|
    t.integer "course_id",    limit: 4
    t.integer "professor_id", limit: 4
    t.float   "rating",       limit: 53
    t.float   "difficulty",   limit: 53
    t.float   "gpa",          limit: 53
  end

  add_index "stats", ["course_id", "professor_id"], name: "index_stats_on_course_id_and_professor_id", unique: true, using: :btree
  add_index "stats", ["course_id"], name: "index_stats_on_course_id", using: :btree
  add_index "stats", ["professor_id"], name: "index_stats_on_professor_id", using: :btree

  create_table "student_majors", force: :cascade do |t|
    t.integer  "student_id", limit: 4
    t.integer  "major_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "student_majors", ["major_id"], name: "index_student_majors_on_major_id", using: :btree
  add_index "student_majors", ["student_id"], name: "index_student_majors_on_student_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.decimal  "grad_year",            precision: 4, default: 0
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "subdepartments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "mnemonic",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "textbook_transactions", force: :cascade do |t|
    t.integer  "seller_id",  limit: 4,     null: false
    t.integer  "buyer_id",   limit: 4
    t.integer  "book_id",    limit: 4,     null: false
    t.integer  "price",      limit: 4,     null: false
    t.string   "condition",  limit: 255,   null: false
    t.text     "notes",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "sold_at"
  end

  add_index "textbook_transactions", ["book_id"], name: "index_textbook_transactions_on_book_id", using: :btree
  add_index "textbook_transactions", ["buyer_id"], name: "index_textbook_transactions_on_buyer_id", using: :btree
  add_index "textbook_transactions", ["seller_id", "buyer_id"], name: "index_textbook_transactions_on_seller_id_and_buyer_id", using: :btree
  add_index "textbook_transactions", ["seller_id"], name: "index_textbook_transactions_on_seller_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "cellphone",              limit: 255
    t.string   "old_password",           limit: 255
    t.integer  "student_id",             limit: 4
    t.integer  "professor_id",           limit: 4
    t.boolean  "subscribed_to_email"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["professor_id"], name: "index_users_on_professor_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["student_id"], name: "index_users_on_student_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",                      default: false, null: false
    t.integer  "voteable_id",   limit: 4,                   null: false
    t.string   "voteable_type", limit: 255,                 null: false
    t.integer  "voter_id",      limit: 4
    t.string   "voter_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
