require_relative "ExpressionElements"

class OperationSub  < ExpressionElements
  def initialize
    @expression = "-"
  end

  def getString
    @expression
  end
end