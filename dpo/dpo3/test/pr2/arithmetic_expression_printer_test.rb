require_relative '../../lib/builder/ArithmeticExpressionCreator'
require_relative '../../lib/builder/ArithmeticExpressionPrinter'

class Arithmetic_expression_printer_test < Test::Unit::TestCase
  def testPrintInOrder1
    e = ArithmeticExpressionCreator.new.createExpression1
    p = ArithmeticExpressionPrinter.new(e)

    assert_equal "(3-(1+2))", p.printInOrder
  end
  
  def testPrintInOrder2
    e = ArithmeticExpressionCreator.new.createExpression2
    p = ArithmeticExpressionPrinter.new(e)
    
    assert "((3-1)+2)", p.printInOrder
  end

  def testPrintInOrder3
    e = ArithmeticExpressionCreator.new.createExpressionFromRPN("1 2 + 3 4 + -")
    p = ArithmeticExpressionPrinter.new(e)

    assert  "((1+2)-(3+4))", p.printInOrder
  end
  
  def testPrintInOrder4
    e = ArithmeticExpressionCreator.new.createExpressionFromRPN("1")
    p = ArithmeticExpressionPrinter.new(e)
    
    assert "1", p.printInOrder
  end

  def testPrintPostOrder1

    e = ArithmeticExpressionCreator.new.createExpression1
    p = ArithmeticExpressionPrinter.new(e)
    
    assert "3 1 2 + -", p.printPostOrder
  end

  def testPrintPostOrder2
    e = ArithmeticExpressionCreator.new.createExpression2
    p = ArithmeticExpressionPrinter.new(e)
    
    assert "3 1 - 2 +", p.printPostOrder
  end
  
  def testPrintPostOrder3
    e = ArithmeticExpressionCreator.new.createExpressionFromRPN("1 2 + 3 4 + -")
    p = ArithmeticExpressionPrinter.new(e)
    
    assert "1 2 + 3 4 + -", p.printPostOrder
  end

  def testPrintPostOrder4
    e = ArithmeticExpressionCreator.new.createExpressionFromRPN("1")
    p = ArithmeticExpressionPrinter.new(e)

    assert  "1", p.printInOrder
  end 
end