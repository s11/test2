require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/edit.html" do
  subject do
    render 'accounts/edit.html'
    response
  end

  it "should render" do
    should be
  end
end
