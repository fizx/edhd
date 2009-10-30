require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "IOObserver" do
  
  before do 
    @observer = IOObserver.new(StringIO.new(@string = ""))
  end
  
  it "should log to the io stream" do
    @observer.hypothesized "experiment", "hypothesis", "seed"
    @string.length.should > 0
  end
  
  it "should log to the io stream" do
    @observer.observed "event", "value", "seed"
    @string.length.should > 0
  end
end
