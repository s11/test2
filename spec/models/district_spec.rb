# == Schema Information
# Schema version: 20091007002944
#
# Table name: districts
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)     not null
#  client_count :integer(4)      default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#  lock_version :integer(4)      default(1), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe District do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :client_count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    District.create!(@valid_attributes)
  end
end
