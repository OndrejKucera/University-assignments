#
# TODO: navrhuji jako properties predavat tridu Hash (neco jako JSON), napriklad:
#
#       jeskyne = build_room({'name'=>'jeskyne', 
#                            'items'=>[Item.new('Louč')],
#                           })
#
require_relative 'room'
require_relative 'item'
require_relative 'condition'
require_relative 'door'
require_relative 'person'

class Build_world
  
  def initialize(model)
    @model = model
  end
  
  def build_room(name = "Some Room", array_items = [], array_doors = [], array_people = [], hash_conditions = {})
     return Room.new(name,array_items,array_doors,array_people,hash_conditions)
  end

  def build_item_in_room(room, name = "Some Item", hash_conditions = {})
    new_item = Item.new(@model,name,hash_conditions)
    room.array_items.push(new_item)
    puts "item #{room.array_items.size}"
    return new_item
  end

  def build_person_in_room(room, name="Some NPC", dialog = "Hi, traveller!", array_items = [], hash_conditions = {})
    new_person = Person.new(name,dialog,array_items,hash_conditions)
    room.array_people.push(new_person)
    return new_person
  end

  def build_door_in_room(from, to = nil, hash_conditions = {})
    new_door = Door.new(@model,from,to,hash_conditions)
    from.array_doors.push(new_door)
    return new_door
  end

  def build_condition( item_or_room_or_person_or_door, name_condition, condition)
    new_condition = Condition.new(@model, condition)
    # FIXME: tohle bude pomerne nebezpecny, predpokladam,
    #        ze ta promenna bude mit Hash hash_conditions
    #        chtelo by to mozna nejake osetreni vyjimky..
    item_or_room_or_person_or_door.hash_conditions.merge!({name_condition => new_condition})
    return new_condition
  end
end