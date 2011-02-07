NetSuite.configure do |config|
  config.passport_email    = Settings.netsuite.soap.email
  config.passport_password = Settings.netsuite.soap.password
  config.passport_account  = Settings.netsuite.soap.account
end
