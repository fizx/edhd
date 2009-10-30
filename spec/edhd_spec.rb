require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class QuietObserver
  def method_missing(*args);end
end

describe "Edhd" do
  before do
    @a = 0
    @b = 0
    $observer = QuietObserver.new
  end
  
  it "should define #experiment" do
    Kernel.should respond_to(:experiment)
  end
  
  it "should define #hypothesis" do
    Kernel.should respond_to(:hypothesis)
  end

  it "should define #observation" do
    Kernel.should respond_to(:observation)
  end
  
  context "one hypothesis" do
    it "should execute the hypothesis" do 
      experiment do
        hypothesis "a" do
          @a = 1
        end
      end
      @a.should == 1
    end
  end
  
  context "multiple hypotheses" do
    it "should execute only one" do
      experiment do
        hypothesis "a" do
          @a += 1
        end
        hypothesis "b" do
          @a += 1
        end
      end
      @a.should == 1
    end
    
    it "should execute randomly if no seed provided" do
      100.times do
        experiment do
          hypothesis "a" do
            @a += 1
          end
          hypothesis "b" do
            @b += 1
          end
        end
      end
      @a.should > 0
      @b.should > 0
      (@a + @b).should == 100
    end
    
    it "should execute deterministically if a seed is provided" do
      100.times do
        experiment "seeded experiment", "ADSF" do
          hypothesis "a" do
            @a += 1
          end
          hypothesis "b" do
            @b += 1
          end
        end
      end
      @a.should == 0
      @b.should == 100
    end
    
    it "should call hypotheses more often if weighted higher" do
      5.times do 
        @a = 0
        @b = 0
        100.times do
          experiment do
            hypothesis "a", 3 do
              @a += 1
            end
            hypothesis "b" do
              @b += 1
            end
          end
        end
        @a.should > @b
      end
    end
  end
  
  context "with an observer" do
    class TestObserver
      def initialize(events = [])
        @events = events
      end
      def hypothesized(*args)
        @events << [:hypothesis] + args
      end
      def observed(*args)
        @events << [:observation] + args
      end
    end
    
    before do
      $observer = TestObserver.new(@events = [])
    end
    
    it "should record the hypothesis chosen" do
      experiment "name", "seed" do
        hypothesis "a", 3 do
          @a += 1
        end
        hypothesis "b" do
          @b += 1
        end
      end
      @events.length.should == 1
      type, exp, hypo, seed = @events.first
      type.should == :hypothesis
      exp.should == "name"
      hypo.should == "a"
      seed.should == "seed"
    end
    
    it "should record observations" do
      experiment "name", "seed" do
        hypothesis "a", 3 do
          @a += 1
        end
        hypothesis "b" do
          @b += 1
        end
      end
      observation "value of a", @a, "seed"
      
      @events.length.should == 2
      type, exp, hypo, seed = @events.first
      type.should == :hypothesis
      exp.should == "name"
      hypo.should == "a"
      seed.should == "seed"
      
      type, name, value, seed = @events.last
      type.should == :observation
      name.should == "value of a"
      value.should == 1
      seed.should == "seed"
    end
    
  end
end
