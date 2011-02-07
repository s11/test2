class Mssql::JbpAccessCode < ActiveRecord::Base
  #connect to the jbp sequel server
  establish_connection :cdx_jbp
    
  class << self
    # function which checks with the jbp ucs database to see if the current code is valid and unredeemed
    def valid_code?(code)
      execute_procedure(:usp_sCDX_validate_usecode, code).first.andand[:errorFlag] === '0'
    end
    
    def redeem_code(code, user)
      # redeem a code and associate it with the inputed user
      valid_code?(code) && execute_procedure(:usp_iCDXValidateAndRedeemUsecode, code, user.id).first.andand[:errorFlag] === '0'
    end
  end
end
