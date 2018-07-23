require_relative "ExpressionElements"

class BracketOpen  < ExpressionElements
  def initialize
    @expression = "("
  end

  def getString
    @expression
  end
end