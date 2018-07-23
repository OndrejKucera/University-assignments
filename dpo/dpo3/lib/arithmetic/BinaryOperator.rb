require_relative 'ArithmeticExpression'

class BinaryOperator < ArithmeticExpression

  def initialize(op1,op2)
    @childs = [op1,op2]
  end
  
  def evaluate
  end
end