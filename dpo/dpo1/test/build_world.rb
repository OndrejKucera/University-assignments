require_relative '../lib/controller'
require_relative '../lib/build_world'
require_relative '../lib/hash'

class Test_Build_World < Test::Unit::TestCase
  def test_build_room
     controller = Controller.new
     builder = Build_world.new(controller.model)
     room = builder.build_room()
  end

  def test_build_item_in_room
    controller = Controller.new
    builder = Build_world.new(controller.model)
    room = Room.new()
    item = builder.build_item_in_room(room)
    expected = room.array_items.include?(item)
    assert_equal expected, true
  end

  def test_build_person_in_room
    controller = Controller.new
    builder = Build_world.new(controller.model)
    room = Room.new()
    person = builder.build_person_in_room(room)
    expected = room.array_people.include?(person)
    assert_equal expected, true
  end

  def test_build_door_in_room
    controller = Controller.new
    builder = Build_world.new(controller.model)
    room_from = Room.new()
    room_to = Room.new()
    door = builder.build_door_in_room(room_from, room_to)
    expected = room_from.array_doors.include?(door)
    assert_equal expected, true
  end

  def test_build_condition
    controller = Controller.new
    builder = Build_world.new(controller.model)
    cond = Hash.new({'test'=>true})

    room = builder.build_room()
    item = builder.build_item_in_room(room)
    person = builder.build_person_in_room(room)
    door = builder.build_door_in_room(room)

    condition_room = builder.build_condition(room, 'test_condition', cond)
    condition_item = builder.build_condition(item, 'test_condition', cond)
    condition_person = builder.build_condition(person, 'test_condition', cond)
    condition_door = builder.build_condition(door, 'test_condition', cond)
    
    assert_equal room.hash_conditions.deep_include?({'test_condition'=>condition_room}), true
    assert_equal item.hash_conditions.deep_include?({'test_condition'=>condition_item}), true
    assert_equal person.hash_conditions.deep_include?({'test_condition'=>condition_person}), true
    assert_equal door.hash_conditions.deep_include?({'test_condition'=>condition_door}), true
  end
end