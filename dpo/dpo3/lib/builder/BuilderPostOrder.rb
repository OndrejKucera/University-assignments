require_relative 'Builder'

class BuilderPostOrder < Builder
  def initialize(arithmetic_expression)
    it = arithmetic_expression.getPostOrderIterator

    @result = build(it)
  end

  def getString
    @result
  end
end