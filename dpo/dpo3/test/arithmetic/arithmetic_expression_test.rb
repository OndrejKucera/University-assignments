require_relative '../../lib/builder/ArithmeticExpressionCreator'

class Arithmetic_expression_test < Test::Unit::TestCase
  #  /**
  #   * I would like not to use getRoot() at all.
  #   */
  #  @Test(expected = UnsupportedOperationException.class)
  def testGetRoot
    assert_raise NoMethodError do
      e = ArithmeticExpressionCreator.new.createExpression1
      e.getRoot
    end
  end

  def testGetInOrderIterator
  #     Creates 3 - (1 + 2)
    e = ArithmeticExpressionCreator.new.createExpression1
    it = e.getInOrderIterator
    assert_not_nil it

    assert "(", it.next.getString
    assert "3", it.next.getString
    assert "-", it.next.getString
    assert "(", it.next.getString
    assert "1", it.next.getString
    assert "+", it.next.getString
    assert "2", it.next.getString
    assert ")", it.next.getString
    assert ")", it.next.getString
    assert_equal(false, it.hasNext)
  end

  def testGetInOrderIteratorRemove
  #    Creates 3 - (1 + 2)
    assert_raise NoMethodError do
      e = ArithmeticExpressionCreator.new.createExpression1
      it = e.getInOrderIterator
      assert_not_nil it
      it.remove
    end
  end

  
  def testGetPostOrderIterator
    e = ArithmeticExpressionCreator.new.createExpression1
    it = e.getPostOrderIterator
    assert_not_nil it
    
    #   Creates 3 - (1 + 2)
    assert  "3", it.next.getString
    assert  "1", it.next.getString
    assert  "2", it.next.getString
    assert  "+", it.next.getString
    assert  "-", it.next.getString
    assert_equal(false, it.hasNext)
  end

  def testGetPostOrderIteratorRemove
    #  Creates 3 - (1 + 2)
    assert_raise NoMethodError do
      e = ArithmeticExpressionCreator.new.createExpression1
      it = e.getPostOrderIterator
      assert_not_nil it
      it.remove
    end
  end
    
end