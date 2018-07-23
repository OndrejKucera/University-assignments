class Door
  
  attr_accessor :from_room, :to_room, :hash_conditions
  
  def initialize(model, from_room = nil, to_room = nil, hash_conditions = {})
    @model = model
    @from_room = from_room
    @to_room = to_room
    @hash_conditions = hash_conditions
    # every door will have condition 'able_pass_door' and default set it to true
    if @hash_conditions.include?('able_pass_door') != true
      @hash_conditions.merge!( { 'able_pass_door' => Condition.new(@model) } )
    end
  end
  
  # convert to String
  def info
    "Door #{from_room.name} -> #{to_room.name} with conditions: #{@hash_conditions.to_s}"
  end
end