require_relative '../arithmetic/AddOperator'
require_relative '../arithmetic/SubstractOperator'
require_relative '../arithmetic/NumericOperand'

class BuilderExpression
  def initialize
    @stack = []
  end
  
  def buildAdd
    op2 = @stack.pop
    op1 = @stack.pop
    @stack.push(AddOperator.new(op1,op2))
  end
  
  def buildSub
    op2 = @stack.pop
    op1 = @stack.pop
    @stack.push(SubstractOperator.new(op1,op2))
  end
  
  def buildNum(char)
    @stack.push(NumericOperand.new(char.to_i))
  end
  
  def getTree
    if @stack.empty?
      raise ArgumentError
    end
    return @stack.first
  end
end