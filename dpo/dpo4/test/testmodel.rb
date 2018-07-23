require 'test/unit'
require_relative '../lib/model'

class Test_model < Test::Unit::TestCase
  def setup
    @model = Model.new
  end
  
  def test_create_circle
    assert_equal true, @model.create_circle(20,10,5)
  end

  def test_create_circle_bad_r
    assert_equal false, @model.create_circle(20,10,-5)
  end
  
  def test_create_square
    assert_equal true, @model.create_square(20,10,5)
  end

  def test_create_square_bad_a
    assert_equal false, @model.create_square(20,10,-5)
  end
  
  def test_change
    @model.create_square(20,10,5)
    assert_equal true, @model.change(20, 10, 50, 1)
    assert_equal false, @model.change(20, 10, 50, -1)
  end

  def test_update
    @model.create_square(20,10,5)
    assert_equal true, @model.update()
  end
  
  def test_clear_all
    @model.create_square(20,10,5)
    @model.create_circle(10,10,5)
    assert_equal true, @model.clear_all
  end
end