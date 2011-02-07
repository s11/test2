# == Schema Information
# Schema version: 20091007002944
#
# Table name: activity_logs
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)      not null
#  login_at         :datetime        not null
#  category_item_id :integer(4)      not null
#  element          :string(255)     not null
#  opened_at        :datetime        not null
#  closed_at        :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivityLog do
  subject do
    ActivityLog.new
  end

  it "should be valid" do
    should be_valid
  end
end
