class Person

  attr_accessor :name, :array_item, :hash_conditions, :dialog
  
  def initialize(name="Some NPC", dialog = "Hi, traveller!", array_items = [], hash_conditions = {})
    @name = name
    @dialog = dialog
    @array_items = array_items
    @hash_conditions = hash_conditions
  end
  
  def talk
    "#{@name}: #{@dialog}"
  end
  
end