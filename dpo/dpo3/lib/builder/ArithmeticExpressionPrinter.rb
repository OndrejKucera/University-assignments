require_relative 'Director'
require_relative 'BuilderPostOrder'
require_relative 'BuilderInOrder'

class ArithmeticExpressionPrinter < Director
  def initialize(arithmetic_expression)
    @expression = arithmetic_expression
  end
  
  def printPostOrder
    BuilderPostOrder.new(@expression).getString
  end
  
  def printInOrder
    BuilderInOrder.new(@expression).getString
  end
end