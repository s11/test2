require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/search/moodle.html" do
  subject do
    render 'search/moodle.html'
    response
  end

  it "should render" do
    should be
  end
end
