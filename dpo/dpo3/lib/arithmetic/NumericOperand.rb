require_relative 'ArithmeticExpression'
require_relative 'elements/Number'

class NumericOperand < ArithmeticExpression
  def initialize(op)
    @number = op
  end
  
  def evaluate
    @number
  end
  
  def getInOrder
    [Number.new(@number)]
  end

  def getPostOrder
    [Number.new(@number)]
  end
  
end