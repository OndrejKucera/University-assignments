require_relative 'BinaryOperator'
require_relative 'elements/OperationAdd'
require_relative 'elements/BracketOpen'
require_relative 'elements/BracketClose'

class AddOperator < BinaryOperator
  def initialize(op1,op2)
    super(op1,op2)

    @child = [op1,op2]
  end
  
  def evaluate
    getFirstOperand.evaluate + getSecondOperand.evaluate
  end


  def getInOrder
    first = getFirstOperand.getInOrder
    second = getSecondOperand.getInOrder
    open = [BracketOpen.new]
    close = [BracketClose.new]
    operation = [OperationAdd.new]

    open + first + operation + second + close
  end


  def getPostOrder
    first = getFirstOperand.getPostOrder
    second = getSecondOperand.getPostOrder
    operation = [OperationAdd.new]

    first + second + operation
  end


  def getFirstOperand
    @child[0]
  end


  def getSecondOperand
    @child[1]
  end
  
  
end