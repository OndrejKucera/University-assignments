require_relative '../lib/person'

class Test_Person < Test::Unit::TestCase
  def test_person
    room = Room.new('test-room', "test")
    npc = Person.new("Test-Person", "Test-Dialog")
    expected = npc.talk
    assert_equal expected, "Test-Person: Test-Dialog"
  end
end