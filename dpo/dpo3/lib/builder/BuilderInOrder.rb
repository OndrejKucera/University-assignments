require_relative 'Builder'

class BuilderInOrder < Builder

  def initialize(arithmetic_expression)
    it = arithmetic_expression.getInOrderIterator

    @result = build(it)
  end

  def getString
    @result
  end
end