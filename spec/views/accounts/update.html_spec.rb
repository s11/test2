require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/update.html" do
  subject do
    render 'accounts/update.html'
    response
  end

  it "should render" do
    should be
  end
end
