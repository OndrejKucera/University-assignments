require_relative "ExpressionElements"

class Number < ExpressionElements
  def initialize(value)
    @expression = value
  end

  def getString
    @expression.to_s
  end
end