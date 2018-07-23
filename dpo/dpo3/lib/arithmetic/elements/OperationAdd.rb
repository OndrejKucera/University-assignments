require_relative "ExpressionElements"

class OperationAdd  < ExpressionElements
  def initialize
    @expression = "+"
  end

  def getString
    @expression
  end
end