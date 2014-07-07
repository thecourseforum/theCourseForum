#!/usr/bin/env ruby

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