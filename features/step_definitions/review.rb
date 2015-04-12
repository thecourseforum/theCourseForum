Given /^I navigate to write a review/ do
  find('a[href="/reviews/new"]').click
end

Then /^I should see '([^"]*)'/ do |text|
  expect(page).to have_content text
end

When /^I write a review/ do
  select "Computer Science (CS)", :from => '#subdept_select'
  select "CS 2150", :from => '#course_select'
  select "Floryan, Mark", :from => '#prof_select'
  select "Fall", :from => '#semester_season'
  select "2015", :from => '#semester_year'
  page.execute_script("$('.prof-rating-slider').slider('value', 1)")
  page.execute_script("$('.enjoyability-slider').slider('value', 1)")
  page.execute_script("$('.-slider').slider('value', 1)")
  page.execute_script("$('.prof-rating-slider').slider('value', 1)")
end