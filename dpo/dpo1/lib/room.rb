class Room
  
  attr_accessor :name, :array_items, :array_doors, :array_people, :hash_conditions
  
  def initialize(name = "Some Room", array_items = [], array_doors = [], array_people = [], hash_conditions = {})
    @name = name
    @array_items = array_items
    @array_doors = array_doors
    @array_people = array_people
    @hash_conditions = hash_conditions
  end
  
end