#!/usr/bin/env ruby

def confirm_all

  User.all.each do |user|
    puts user.id
    if (user.confirmed_at == nil)
      user.confirmed_at = user.created_at
      user.save
    end
  end
end

confirm_all

