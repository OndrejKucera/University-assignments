require_relative 'condition'

class Item

  attr_reader :name, :hash_conditions
  
  def initialize(model, name = "Some Item", hash_conditions = {})
    @model = model
    @hash_conditions = hash_conditions
 
    # every item will have condition 'able_pick_up' and default set it to true
    if @hash_conditions.include?('able_pick_up') != true
      @hash_conditions.merge!( { 'able_pick_up' => Condition.new(@model) } )
    end

    # every item will have condition 'able_use' and default set it to true
    if @hash_conditions.include?('able_use') != true
      @hash_conditions.merge!( { 'able_use' => Condition.new(@model) } )
    end
    
    @name = name
  end
  
end