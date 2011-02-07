require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/message_recipients/index.html" do
  subject do
    render 'message_recipients/index.html'
    response
  end

  it "should render" do
    should be
  end
end
