#--
#  20091004001022_create_districts.rb
#  management
#  
#  Created by John Meredith on 2009-10-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts, :options => 'ENGINE MyISAM COLLATE utf8_general_ci' do |t|
      t.string  :name,          :null => false
      t.integer :client_count,  :null => false, :default => 0

      # Basic auditing
      t.timestamps
      t.datetime  :deleted_at
      t.integer   :lock_version,  :null => false, :default => 1
    end
    
    add_index :districts, :name, :name => :idx_name
  end

  def self.down
    drop_table :districts
  end
end
