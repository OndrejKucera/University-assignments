require_relative '../../lib/builder/ArithmeticExpressionCreator'

class Arithmetic_expression_creator_test < Test::Unit::TestCase

  def testCreateExpression1
    aec = ArithmeticExpressionCreator.new
    assert_equal 0, aec.createExpression1.evaluate
  end

  def testCreateExpression2
    aec = ArithmeticExpressionCreator.new;
    assert_equal 4, aec.createExpression2.evaluate;
  end
  
  def testCreateExpressionFromRPN1
    aec = ArithmeticExpressionCreator.new
    assert_equal 4, aec.createExpressionFromRPN("3 1 +").evaluate

    assert_equal 0, aec.createExpressionFromRPN("3 1 2 + -").evaluate
    
    assert_equal 0, aec.createExpressionFromRPN("1 2 3 - +").evaluate

    assert_equal -2, aec.createExpressionFromRPN("3 1 + 4 - 2 -").evaluate
  end

  def testCreateExpressionFromRPN2
    aec = ArithmeticExpressionCreator.new;
    assert_equal 1, aec.createExpressionFromRPN("1").evaluate
  end

  def testCreateExpressionFromRPN3
    assert_raise ArgumentError do
      aec = ArithmeticExpressionCreator.new;
      assert_equal  1, aec.createExpressionFromRPN("1 2 Baf").evaluate
    end
  end

#  /**
#   * Empty expression is not valid expression
#   */
  def testCreateExpressionFromRPN4
    assert_raise ArgumentError do
      aec = ArithmeticExpressionCreator.new
      assert_equal  1, aec.createExpressionFromRPN("").evaluate
     end
  end

end