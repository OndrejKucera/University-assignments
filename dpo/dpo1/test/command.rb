require_relative '../lib/controller'
require_relative '../lib/command'

class Test_Command  < Test::Unit::TestCase
  def test_go_to
    controller = Controller.new()
    model = controller.model()
    view = controller.view()
    room_from = Room.new('room-from')
    room_to = Room.new('room-to')
    door = Door.new(model, room_from, room_to)
    
    commander_crate = Commander_crate.new(model, view)
    commander_crate.command = Command_Go_to.new 
    command_go_to = Commander.new(commander_crate)     
    expected = command_go_to.on_execute(door)
    assert_equal expected, true
    assert_equal model.player.location, room_to
  end

  def test_pick_up
    controller = Controller.new()
    model = controller.model()
    view = controller.view()
    room = Room.new()
    model.player.location = room
    item = Item.new(model)
    room.array_items.push(item)

    commander_crate = Commander_crate.new(model, view)
    commander_crate.command = Command_Pick_up.new 
    command_pick_up = Commander.new(commander_crate)     
    expected = command_pick_up.on_execute(item)
    assert_equal expected, true
    assert_equal model.player.bag_of_items.include?(item), true
  end

  def test_put_down
    controller = Controller.new()
    model = controller.model()
    view = controller.view()
    room = Room.new()
    model.player.location = room
    item = Item.new(model)
    model.player.bag_of_items.push(item)

    commander_crate = Commander_crate.new(model, view)
    commander_crate.command = Command_Put_down.new 
    command_put_down = Commander.new(commander_crate)     
    expected = command_put_down.on_execute(item)
    assert_equal expected, true
    assert_equal model.player.bag_of_items.include?(item), false
    assert_equal room.array_items.include?(item), true
  end

  def test_talk
    controller = Controller.new()
    model = controller.model()
    view = controller.view()
    npc = Person.new('NPC','test')
    
    commander_crate = Commander_crate.new(model, view)
    commander_crate.command = Command_Talk.new
    command_talk = Commander.new(commander_crate)     
    expected = command_talk.on_execute(npc)
    assert_equal expected, true
  end

  def test_use
    controller = Controller.new()
    model = controller.model()
    view = controller.view()
    room = Room.new()
    model.player.location = room
    item = Item.new(model)
    model.player.bag_of_items.push(item)
    
    commander_crate = Commander_crate.new(model, view)
    commander_crate.command = Command_Use.new
    command_use = Commander.new(commander_crate)     
    expected = command_use.on_execute(item)
    assert_equal expected, true
    #assert_equal model.player.bag_of_items.include?(item), false
  end
end