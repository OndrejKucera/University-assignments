require_relative 'IteratorInOrder'
require_relative 'IteratorPostOrder'

class ArithmeticExpression
  
  def initialize(root = nil)
    @root = root
  end
  
  def evaluate
    if @root == nil
      raise ArgumentError
    end
    @root.evaluate
  end
  
  def getInOrderIterator
    IteratorInOrder.new(@root)
  end
  
  def getPostOrderIterator
    IteratorPostOrder.new(@root)
  end
end