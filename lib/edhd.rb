require File.dirname(__FILE__) + "/io_observer"
module Kernel
  $observer = IOObserver.new(STDOUT)

  def experiment(name = "default", seed = rand)
    $hypothesis_sets ||= []
    $hypothesis_sets << []
    yield
    hypothesis_set = $hypothesis_sets.pop
    hypothesis_name, block = hypothesis_set[seed.to_s.hash % hypothesis_set.length]
    block.call
    $observer.hypothesized(name, hypothesis_name, seed)
  end
  
  def hypothesis(name, weight = 1, &block)
    weight.times do
      $hypothesis_sets.last << [name, block]
    end
  end
  
  def observation(name, value, seed)
    $observer.observed(name, value, seed)
  end
end