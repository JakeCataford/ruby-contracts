require_relative '../lib/contracts'

class SampleContractClass
  using Contracts
  must_implement :hello_world

  def hello_world
    puts "Hello World"
  end
end

class SampleUnfulfilledContractClass
  using Contracts
  must_implement :not_implemented
end

o = SampleContractClass.new

begin
  o = SampleUnfulfilledContractClass.new
  puts "Contract not successfully enforced."
rescue Contracts::UnsatisfiedContractException => e
  puts "Successfully enforced contract."
  puts e.message
end
