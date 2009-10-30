class IOObserver
  def initialize(io)
    @io = io
  end
  
  def hypothesized(experiment, hypothesis, seed)
    @io.puts "#{Time.now.to_i}\thypothesis\t#{experiment}\t#{hypothesis}\t#{seed}"
  end
  
  def observed(name, value, seed)
    @io.puts "#{Time.now.to_i}\tobservation\t#{name}\t#{value}\t#{seed}"
  end
end