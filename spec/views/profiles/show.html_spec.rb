require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/profiles/show.html" do
  subject do
    render 'profiles/show.html'
    response
  end

  it "should render" do
    should be
  end
end
