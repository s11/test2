# == Schema Information
# Schema version: 20091007002944
#
# Table name: class_groups
#
#  id           :integer(4)      not null, primary key
#  client_id    :integer(4)      not null
#  name         :string(255)     not null
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#  lock_version :integer(4)      default(1), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClassGroupie do
  subject do
    ClassGroupie.new
  end

  it "should be valid" do
    should be_valid
  end
end
