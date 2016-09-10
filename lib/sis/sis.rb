require 'selenium-webdriver'

credentials = File.open('credentials', 'r').read

puts 'opening browser...'
driver = Selenium::WebDriver.for :firefox
# driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://sisuva.admin.virginia.edu/psp/ihprd/EMPLOYEE/EMPL/h/?tab=PAPP_GUEST"

puts 'authenticating via netbadge...'

# wait for netbadge
wait = Selenium::WebDriver::Wait.new(:timeout => 60)
wait.until { driver.find_element(:css => 'input[name=Netbadge]').displayed? }
driver.find_element(:name => 'Netbadge').click

# wait for netbadge to load
wait.until { driver.find_element(:name => 'user').displayed? }
driver.find_element(:name => 'user').send_key(credentials.split(':').first)
driver.find_element(:name => 'pass').send_key(credentials.split(':').last)
# driver.find_element(:name => 'submit').click
# driver.find_element(:name => 'pass').send_key("\n")

puts 'finishing sis login...'
# wait for iframe for sis finish login
wait.until { driver.find_element(:tag_name => 'iframe').displayed? }
driver.switch_to.frame driver.find_element(:tag_name => 'iframe')

puts 'navigating to what-if...'
# wait for sis content in iframe to load
wait.until { driver.find_element(:name => 'DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').displayed? }
driver.find_element(:name => 'DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').send_key('w')
driver.find_element(:name => 'DERIVED_SSS_SCL_SSS_GO_1').click

# wait for create what-if report page finished
wait.until { driver.find_element(:name => 'DERIVED_SAAWHIF_SSS_CREATE_NEW').displayed? }
driver.find_element(:name => 'DERIVED_SAAWHIF_SSS_CREATE_NEW').click

# wait for detail create what-if report pae finished
wait.until { driver.find_element(:name => 'DERIVED_SAAWHIF_ACAD_PROG$0').displayed? }
driver.find_element(:name => 'DERIVED_SAAWHIF_ACAD_PROG$0').click
driver.find_element(:name => 'DERIVED_SAAWHIF_ACAD_PROG$0').find_elements( :tag_name => "option" ).find do |option|
  option.text.include? 'Arts'
end.click

puts 'choosing ba econ...'
# wait until sis loads all school majors
wait.until { driver.find_element(:name => 'PLAN$0').find_element(:css => '[value=ECON-BA]').displayed? }
driver.find_element(:name => 'PLAN$0').click
driver.find_element(:name => 'PLAN$0').find_elements( :tag_name => "option" ).find do |option|
  option.text.include? 'Economics (BA)'
end.click

# wait for concentrations to load (submitting wont trigger until this is done)
wait.until { driver.find_element(:id => 'WAIT_win0').displayed? }
wait.until { !driver.find_element(:id => 'WAIT_win0').displayed? }

driver.find_element(:name => 'DERIVED_SAAWHIF_SSR_PB_SUBMIT').send_key("\n")

puts 'generating report...'
# wait for report to be finished
wait.until { driver.find_element(:id => 'win0divDERIVED_SAA_DPR_GROUPBOX1$3').displayed? }
driver.find_element(:name => 'DERIVED_SAA_DPR_SSS_EXPAND_ALL').click
# wait for expansion to finish
wait.until { driver.find_element(:id => 'WAIT_win0').displayed? }
wait.until { !driver.find_element(:id => 'WAIT_win0').displayed? }

puts 'parsing information...'
major_element = driver.find_element(:id => 'win0divDERIVED_SAA_DPR_GROUPBOX1$3')
major = {
  :name => major_element.find_element(:id => 'win0divDERIVED_SAA_DPR_GROUPBOX1GP$3').text,
  :text => major_element.find_elements(:tag_name => 'span').find { |span|
    span.text.include? '[RG'
  }.text
}

requirements = major_element.find_element(:id => 'ACE_SAA_ARSLT_RLVW$3')
major[:categories] = []
requirements.find_elements(:xpath => '*/tr').each do |tr|
  category_check = tr.find_elements(:css => '.PAGROUPDIVIDER')
  if category_check.size > 0
    major[:categories] << {
      :name => category_check.first.text,
      :text => tr.text,
      :subcategories => []
    }
  end
  next unless major[:categories].last
  category = major[:categories].last
  category_text_check = tr.find_elements(:css => '.SSSTEXTDKBLUEBOLD10')
  subcategory_check = tr.find_elements(:tag_name => 'span').select do |span|
    span.text.include? '[RQ'
  end
  if subcategory_check.size > 0 and category_text_check.size == 0
    category[:text] = subcategory_check.first.text
    next
  end
  if subcategory_check.size > 0 and category_text_check.size > 0
    category[:subcategories] << {
      :name => tr.find_element(:css => '.SSSTEXTDKBLUEBOLD10').text,
      :text => tr.find_elements(:tag_name => 'span').find { |span|
        span.text.include? '[RQ'
      }.text
    }
  end
end

puts "Major:\t#{major[:name]}"
puts "Major Text:\t#{major[:text]}\n"
major[:categories].each do |category|
  puts "Name:\t#{category[:name]}"
  puts "Category\t#{category[:text]}\n\n"
  category[:subcategories].each do |subcategory|
    puts "Subcategory Name\t\t#{subcategory[:name]}"
    puts "Subcategory Text\t\t#{subcategory[:text]}\n\n"
  end
end