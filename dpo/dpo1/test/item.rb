require_relative '../lib/item'

class Test_Item < Test::Unit::TestCase
  def test_naming
    controller = Controller.new()
    model = controller.model()
    item = Item.new(model,"Nuz")
    expected = "#{item.name()}"
    assert_equal expected, "Nuz"
  end
end