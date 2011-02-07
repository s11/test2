require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InformationController do

  #Delete these examples and add some real ones
  it "should use InformationController" do
    controller.should be_an_instance_of(InformationController)
  end


  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end
end
