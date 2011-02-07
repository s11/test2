require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/print_support/show.html" do
  subject do
    render 'print_support/show.html'
    response
  end

  it "should render" do
    should be
  end
end
