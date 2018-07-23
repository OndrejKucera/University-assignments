require_relative '../arithmetic/AddOperator'
require_relative '../arithmetic/SubstractOperator'
require_relative '../arithmetic/NumericOperand'
require_relative 'BuilderExpression'

class Director
  def initialize
    @builder = BuilderExpression.new()
  end

  def pushPart(char)
    if char == ' '
      # mezery preskocime
    elsif char == '+'
      @builder.buildAdd
    elsif char == '-'
      @builder.buildSub
    elsif char >= '0' && char <= '9'
      @builder.buildNum(char)
    else
      raise ArgumentError
    end
  end
  
  def getResult
    @builder.getTree
  end
end