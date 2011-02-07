# == Schema Information
# Schema version: 20091007002944
#
# Table name: reports
#
#  id                  :integer(4)      not null, primary key
#  type                :string(255)
#  name                :string(255)     not null
#  owner_id            :integer(4)      not null
#  owner_type          :string(255)     not null
#  menu_id             :integer(4)
#  menu_version_id     :integer(4)
#  class_group_id      :integer(4)
#  hierarchy_id        :integer(4)
#  hierarchy_type      :string(255)
#  date_range_start    :datetime
#  date_range_end      :datetime
#  include_all_users   :boolean(1)      default(TRUE), not null
#  include_all_columns :boolean(1)      default(TRUE), not null
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  lock_version        :integer(4)      default(1), not null
#  role                :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Report::Activity do
  subject do
    Report::Activity.new
  end

  it "should be valid" do
    should be_valid
  end
end
