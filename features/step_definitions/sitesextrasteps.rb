Then /^I should see active_menu$/ do
  find("#publisher_status_box")
end

Then /^I should see search_bar$/ do
  find("#publisher_search_field")
end

Then /^I should see paging_bar$/ do
  find("#site_home_button")
  find("#first_page_button")  
  find("#previous_page_button")
  find("#next_page_button")
  find("#last_page_button")
end

Then /^I should see site_list$/ do
  find("#publisher_tree_box")

end

Then /^I should see new site_form$/ do
  #find("#add_new_site_button")
  page.find(".x-window-closable")
end


Then /^I will create a site called 'AA New Site 100'/ do
  find_field('Full Name').set("AA New Site 100")
  find_field('Email').set("RedkeeperTwentyFun@gmail.com")
  click_button('Save')
end

Then /^I click Add Site$/ do
  find(".add-client").click()
end

Then /^I should see this site$/ do
  find('.x-grid-cell-inner', :text => 'AA New Site 100')
end

Then /^I should see Ad placement list within$/ do
  find('.x-btn-inner', :text => "+").click()
  within('.x-layout-fit .x-tree-lines') do
  page.should have_content("Default")
  end
  find('.x-btn-inner', :text => "-").click()
end

Then /^I should not see this site$/ do
  begin
    find('.x-grid-cell-inner', :text => 'AA New Site 101')
    false
  rescue Capybara::ElementNotFound
    true
  end
end

Then /^I should see Overview in site_home$/ do
  find('.x-tab-inner', :text => 'Overview')
end

Then /^I should see Statistics in site_home$/ do
  within page.find("#sites-main") do
    find('.x-tab-inner', :text => 'Statistics').click()
  end
end

Then /^I should see Edit in site_home$/ do
  find('.x-tab-inner', :text => 'Edit')
end

Then /^I should see Links in site_home$/ do
  find('.x-tab-inner', :text => 'Links')
end

When /^select 'AA New Site 100'$/ do
  within page.find("#treepanel-1015") do
    find('.x-grid-row', :text => 'AA New Site 100').click()
  end
end

When /^select 'AA New Site 101'$/ do
  within page.find("#treepanel-1015") do
    find('.x-grid-row', :text => 'AA New Site 101').click()
  end
end
  
When /^change something and click Save_button$/ do
  find_field('Full Name').set("AA New Site 101")
  click_button('Save')
end

When /^click hold in active_menu$/ do
#  find("#publisher_status_box-inputEl").click()
  find(".x-form-arrow-trigger").click()
  find('.x-boundlist-item', :text => 'Hold').click()
end

Then /^I should see on hold publishers$/ do
  page.should have_content("y Hello Thar Hold")
 # find("#publisher_status_box-inputEl").click()
  find(".x-form-arrow-trigger").click()
  find('.x-boundlist-item', :text => 'Active').click()
end

Then /^I should see the change$/ do
  page.should have_content("AA New Site 101")
end