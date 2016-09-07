require 'selenium-webdriver'

credentials = File.open('credentials', 'r').read

# driver = Selenium::WebDriver.for :firefox
driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://sisuva.admin.virginia.edu/psp/ihprd/EMPLOYEE/EMPL/h/?tab=PAPP_GUEST"

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

# wait for iframe for sis finish login
wait.until { driver.find_element(:tag_name => 'iframe').displayed? }
driver.switch_to.frame driver.find_element(:tag_name => 'iframe')

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

# wait for report to be finished
wait.until { driver.find_element(:id => 'win0divDERIVED_SAA_DPR_GROUPBOX1$2').displayed? }
driver.find_element(:name => 'DERIVED_SAA_DPR_SSS_EXPAND_ALL').click
# wait for expansion to finish
wait.until { driver.find_element(:id => 'WAIT_win0').displayed? }
wait.until { !driver.find_element(:id => 'WAIT_win0').displayed? }

major = driver.find_element(:id => 'win0divDERIVED_SAA_DPR_GROUPBOX1$2')
