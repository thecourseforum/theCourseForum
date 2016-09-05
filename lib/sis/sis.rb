require 'selenium-webdriver'

credentials = File.open('credentials', 'r').read

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://sisuva.admin.virginia.edu/psp/ihprd/EMPLOYEE/EMPL/h/?tab=PAPP_GUEST"

wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.find_element(:name => 'Netbadge').displayed? }

driver.find_element(:name => 'Netbadge').click
driver.find_element(:name => 'user').send_key(credentials.split(':').first)
driver.find_element(:name => 'pass').send_key(credentials.split(':').last)
# driver.find_element(:name => 'submit').click
# driver.find_element(:name => 'pass').send_key("\n")
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.find_element(:tag_name => 'iframe').displayed? }
driver.switch_to.frame driver.find_element(:tag_name => 'iframe')
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.find_element(:name => 'DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').displayed? }
driver.find_element(:name => 'DERIVED_SSS_SCL_SSS_MORE_ACADEMICS').send_key('w')
driver.find_element(:name => 'DERIVED_SSS_SCL_SSS_GO_1').click
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.find_element(:name => 'DERIVED_SAAWHIF_SSS_CREATE_NEW').displayed? }
driver.find_element(:name => 'DERIVED_SAAWHIF_SSS_CREATE_NEW').click
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.find_element(:name => 'DERIVED_SAAWHIF_ACAD_PROG$0').displayed? }
driver.find_element(:name => 'DERIVED_SAAWHIF_ACAD_PROG$0').send_key('Arts & Sciences')
driver.find_element(:name => 'PLAN$0').send_key('Economics (BA)')
driver.execute_script("submitAction_win0(document.win0,'DERIVED_SAAWHIF_SSR_PB_SUBMIT');")
