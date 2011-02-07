#--
#  20091004003019_add_clients_districts_table.rb
#  management
#  
#  Created by John Meredith on 2009-10-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class AddClientsDistrictsTable < ActiveRecord::Migration
  def self.up
    create_table :clients_districts, :id => false, :options => 'ENGINE MyISAM COLLATE utf8_general_ci', :force => true do |t|
      t.references :district, :null => false
      t.references :client,   :null => false
    end
    
    add_index :clients_districts, [:district_id, :client_id], :unique => true, :name => :idx_unique
    add_index :clients_districts, :district_id, :name => :idx_district
    add_index :clients_districts, :client_id,   :name => :idx_client
  end

  def self.down
    drop_table :clients_districts
  end
end
