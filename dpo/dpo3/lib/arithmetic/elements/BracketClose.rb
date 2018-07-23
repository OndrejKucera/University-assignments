require_relative "ExpressionElements"

class BracketClose  < ExpressionElements
  def initialize
    @expression = ")"
  end

  def getString
    @expression
  end
end