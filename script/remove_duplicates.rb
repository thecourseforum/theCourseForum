#!/usr/bin/env ruby

def remove_duplicates
  all_emails = []
  duplicate_emails = []

  User.all.each do |user|
    if (all_emails.include? user.email)
      user.delete
      duplicate_emails.push(user.email)
    else
      all_emails.push(user.email)
    end
  end
end

remove_duplicates

