require_relative '../lib/model'
require_relative '../lib/condition'
require_relative '../lib/room'

class Test_Condition < Test::Unit::TestCase
  
  def test_emptyCondition
    controller = Controller.new()
    model = controller.model()
    cond = Condition.new(model)
    expected = cond.is_passed?()
    assert_equal expected, true
  end
  
  def test_playerIsInSameRoom
    controller = Controller.new()
    model = controller.model()
    room = Room.new
    model = Model.new
    model.player.location = room
    cond = Condition.new(model, room)
    expected = cond.is_passed?()
    assert_equal expected, true
  end
  
  def test_PlayerIsInAnotherRoom
    controller = Controller.new()
    model = controller.model()
    room1 = Room.new
    room2 = Room.new
    model = Model.new
    player = model.player
    player.location = room1
    cond = Condition.new(model, room2)
    expected = cond.is_passed?()
    assert_equal expected, false
  end
  
  def test_info
    controller = Controller.new()
    model = controller.model()
    room = Room.new
    item1 = Item.new(model,"Nuz")
    item2 = Item.new(model,"Svicka")
    envVar1 = {"convince_a_mage" => true}
    envVar2 = {"killed_dragon" => true}
    cond = Condition.new(model)
    cond.add_condition(room)
    cond.add_condition(item1)
    cond.add_condition(item2)
    cond.add_condition(envVar1)
    cond.add_condition(envVar2)
    expected = cond.info()
    assert_equal expected, "Condition: Player must be in room 'Some Room', Variables Environment: {\"convince_a_mage\"=>true, \"killed_dragon\"=>true}, Player must have in bag: Nuz Svicka"
  end
end