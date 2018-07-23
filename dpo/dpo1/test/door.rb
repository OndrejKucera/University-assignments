require_relative '../lib/door'
require_relative '../lib/room'
require_relative '../lib/controller'

class Test_Door < Test::Unit::TestCase
  def test_door
    controller = Controller.new
    model = controller.model()
    room_from = Room.new('room-from')
    room_to = Room.new('room-to')
    door = Door.new(model, room_from, room_to)
    expected = door.info()
    assert_equal door.from_room, room_from
    assert_equal door.to_room, room_to
  end
end