module Contracts
  class UnsatisfiedContractException < StandardError; end

  refine Class do
    attr_accessor :contracted_methods

    def must_implement(*contracted_methods)
      @contracted_methods = contracted_methods
      class << self
        alias new_alias new
        def new(*args)
          assert_contract_fulfilled(@contracted_methods, self.instance_methods)
          new_alias(*args)
        end
      end
    end

    def assert_contract_fulfilled(contracted_methods, all_methods)
      unfulfilled_contracts = contracted_methods - all_methods
      unless unfulfilled_contracts.empty?
        raise UnsatisfiedContractException.new("Class did not satisfy it's contract on instansiation. The following methods were undefined or not public: #{unfulfilled_contracts}") 
      end
    end
  end
end
