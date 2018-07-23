require_relative '../arithmetic/NumericOperand'
require_relative '../arithmetic/ArithmeticExpression'
require_relative '../arithmetic/AddOperator'
require_relative '../arithmetic/SubstractOperator'
require_relative 'Director'

class ArithmeticExpressionCreator
  
  def createExpression1
    op1 = NumericOperand.new(1)
    op2 = NumericOperand.new(2)
    op3 = NumericOperand.new(3)
    
    o2 = AddOperator.new(op1, op2)
    o1 = SubstractOperator.new(op3, o2)
    
    return ArithmeticExpression.new(o1)
  end

#  /**
#   * Creates (3 - 1) + 2
#   *
#   * This is ugly. I don't like creating expressions in this
#   *  form. I never know, what expression I have created...
#   */
  def createExpression2()
    op1 = NumericOperand.new(1)
    op2 = NumericOperand.new(2)
    op3 = NumericOperand.new(3)
    
    o1 = SubstractOperator.new(op3, op1)
    o2 = AddOperator.new(o1, op2)
    
    return ArithmeticExpression.new(o2)
  end
  
#  /**
#   * Creates any expression from the RPN input. This is nice and
#   *  universal. 
#   * 
#   * @see http://en.wikipedia.org/wiki/Reverse_Polish_notation
#   *  
#   * @param input in Reverse Polish Notation
#   * @return {@link ArithmeticExpression} equivalent to the RPN input.
#   */
  def createExpressionFromRPN(expression)
#    // Good entry point for Builder :)
    director = Director.new
    expression.each_char {|c| director.pushPart(c) }
    return ArithmeticExpression.new(director.getResult)
  end

end