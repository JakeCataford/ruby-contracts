ruby-contracts
======

**When quacks-like isn't good enough. :bird:**

The problem
----

Ruby is a dynamically typed language. This is generally pretty awesome, but sometimes it can get in the way.

The only way to see if a ruby object contractually fulfills an interface, is to check the methods on the interface.
Sometimes, you want the security that the methods you are going to call are definitely going to be defined on a given
object.

Because Ruby is dynamcally typed and methods can be defined on the fly, this library does it's best to make sure that classes
fulfill a contract of public methods when the object is instantiated. Which is when you are most likely to use it.

Usage
----

To use `ruby-contracts`, add it to your gemfile or gem install the dependency:

```Ruby
gem 'ruby-contracts'
```

Then load the class and import the refinement wherever you want to use the method, then use the keyword `must_implement` to
define methods that must be implemented by the time the object is instantiated.

```Ruby
require 'ruby-contracts'

class MyContractEnforcedClass
  using Contracts
  must_implement :this, :also_this, :and_this

  def this
    "this"
  end

  def also_this
    "also this"
  end
end

MyContractEnforcedClass.new

# => UnsatisfiedContractException: Class did not satisfy it's contract on instansiation. The following methods were undefined or not public: [:and_this]
```

It is meant to be included on a superclass, so you can subclass it whenever two or more classes need to adhere to the same contract.

```Ruby
class OtherClass < MyContractEnforcedClass
  # Still enforces ":this, :also_this :and_this"

  def and_this
    "finally!"
  end
end

OtherClass.new
=> <#OtherClass>

```

The Implementation
----

The implementation right now supports instance methods on an object by `refine`ing `Class` and overriding `Class.new` where the refinement is present.
The overridden `Class.new` calls the original `Class.new`, but tests if the contract is fulfilled first.

I used a refinement because monkey patching Class everywhere seemed super gross. So this was a mildly more elegant solution to the problem.

`Class.new` is only overridden if `must_implement` is called as a second safety.

In the future, I would like to support class methods (after the class has been defined maybe?) and ensure that instance methods called are public
and have the correct number of arguments.


