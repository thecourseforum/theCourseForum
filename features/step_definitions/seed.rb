Given /^courses exist$/ do
  unless Course.find_by_mnemonic_number("CS 2150")
    FactoryGirl.create :section_professor
  end
end