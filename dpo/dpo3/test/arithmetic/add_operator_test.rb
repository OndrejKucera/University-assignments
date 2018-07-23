require_relative '../../lib/arithmetic/AddOperator'
require_relative '../../lib/arithmetic/NumericOperand'

class Add_operator_test < Test::Unit::TestCase
  def setup
      #puts 'runs only once at start'
      @o1 = NumericOperand.new(1)
      @o2 = NumericOperand.new(2)
  end
  
  def testGetFirstOperand
    o = AddOperator.new(@o1, @o2)
    assert_equal @o1, o.getFirstOperand
  end

  def testGetSecondOperand
    o = AddOperator.new(@o1, @o2)
    assert_equal @o2, o.getSecondOperand
  end
end