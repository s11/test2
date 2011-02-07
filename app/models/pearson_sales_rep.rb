# 
#  pearson_sales_rep.rb
#  online
#  
#  Created by John Meredith on 2008-08-20.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class PearsonSalesRep < ActiveRecord::Base
  # Attribute properties
  attr_readonly :code
  
  # Validations
  validates_uniqueness_of :code, :on => :create
end
